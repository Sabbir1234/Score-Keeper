package com.example.scorekeeper;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.app.AppCompatDelegate;

import android.os.Bundle;
import android.os.PersistableBundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private ImageButton inc1,inc2,dec1,dec2;
    private TextView t1,t2;
    String s1,s2,s3,s4;
    private int m1,m2;
    static final String stateScoreOne = "Team score 1";
    static final String stateScoreTwo = "Team score 2";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        t1 = findViewById(R.id.score1);
        t2 = findViewById(R.id.score2);
        if(savedInstanceState!=null)
        {
            m1 = savedInstanceState.getInt(stateScoreOne);
            m2 = savedInstanceState.getInt(stateScoreTwo);
            t1.setText(String.valueOf(m1));
            t2.setText(String.valueOf(m2));
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu,menu);
        int nightMOde = AppCompatDelegate.getDefaultNightMode();
        if(nightMOde==AppCompatDelegate.MODE_NIGHT_YES)
        {
            menu.findItem(R.id.night).setTitle(R.string.day_mode);
        }
        else
        {
            menu.findItem(R.id.night).setTitle(R.string.night_mode);
        }
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(@NonNull MenuItem item) {
        if(item.getItemId()==R.id.night)
        {
            int nightMode = AppCompatDelegate.getDefaultNightMode();
            if(nightMode == AppCompatDelegate.MODE_NIGHT_YES)
            {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO);

            }
            else
            {
                AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_YES);

            }
        }
        recreate();
        return true;
    }

    public void perform(View view) {
        switch (view.getId())
        {
            case  R.id.increment1:
                m1++;
                t1.setText(String.valueOf(m1));
                break;
            case  R.id.increment2:
                m2++;
                t2.setText(String.valueOf(m2));
                break;
            case  R.id.decrement1:
                m1--;
                t1.setText(String.valueOf(m1));
                break;
            case  R.id.decrement2:
                m2--;
                t2.setText(String.valueOf(m2));
                break;
        }
    }

    @Override
    public void onSaveInstanceState(@NonNull Bundle outState) {
        outState.putInt(stateScoreOne,m1);
        outState.putInt(stateScoreTwo,m2);
        super.onSaveInstanceState(outState);
    }
}
