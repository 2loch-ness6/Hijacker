package com.hijacker;

/*
    Modern replacement for deprecated AsyncTask using ExecutorService.
    Provides similar API for easier migration from AsyncTask.
    
    This is a lightweight implementation that maintains AsyncTask-like behavior
    while using modern Android concurrency patterns.
*/

import android.os.Handler;
import android.os.Looper;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;

public abstract class ModernAsyncTask<Params, Progress, Result> {
    private static final Executor THREAD_POOL_EXECUTOR =
            Executors.newFixedThreadPool(Runtime.getRuntime().availableProcessors() * 2);
    private final Handler handler = new Handler(Looper.getMainLooper());
    private volatile boolean cancelled = false;

    /**
     * Runs on the UI thread before doInBackground.
     */
    protected void onPreExecute() {
    }

    /**
     * Override this method to perform a computation on a background thread.
     */
    protected abstract Result doInBackground(Params... params);

    /**
     * Runs on the UI thread after doInBackground.
     */
    protected void onPostExecute(Result result) {
    }

    /**
     * Runs on the UI thread if the task was cancelled.
     */
    protected void onCancelled(Result result) {
        onCancelled();
    }

    /**
     * Runs on the UI thread if the task was cancelled.
     */
    protected void onCancelled() {
    }

    /**
     * Runs on the UI thread after publishProgress is invoked.
     */
    protected void onProgressUpdate(Progress... values) {
    }

    /**
     * Returns true if this task was cancelled before it completed.
     */
    public final boolean isCancelled() {
        return cancelled;
    }

    /**
     * Attempts to cancel execution of this task.
     */
    public final boolean cancel(boolean mayInterruptIfRunning) {
        cancelled = true;
        return true;
    }

    /**
     * This method can be invoked from doInBackground to publish updates on the UI thread.
     */
    @SafeVarargs
    protected final void publishProgress(final Progress... values) {
        if (!cancelled) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    if (!cancelled) {
                        onProgressUpdate(values);
                    }
                }
            });
        }
    }

    /**
     * Executes the task with the specified parameters.
     */
    @SafeVarargs
    public final ModernAsyncTask<Params, Progress, Result> execute(final Params... params) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                onPreExecute();
            }
        });

        THREAD_POOL_EXECUTOR.execute(new Runnable() {
            @Override
            public void run() {
                final Result result = doInBackground(params);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (cancelled) {
                            onCancelled(result);
                        } else {
                            onPostExecute(result);
                        }
                    }
                });
            }
        });

        return this;
    }

    /**
     * Executes the task on the specified executor.
     */
    @SafeVarargs
    public final ModernAsyncTask<Params, Progress, Result> executeOnExecutor(
            Executor executor, final Params... params) {
        handler.post(new Runnable() {
            @Override
            public void run() {
                onPreExecute();
            }
        });

        executor.execute(new Runnable() {
            @Override
            public void run() {
                final Result result = doInBackground(params);
                handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (cancelled) {
                            onCancelled(result);
                        } else {
                            onPostExecute(result);
                        }
                    }
                });
            }
        });

        return this;
    }
}
