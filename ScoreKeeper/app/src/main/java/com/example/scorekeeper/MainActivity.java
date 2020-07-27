package com.example.scorekeeper;

import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private ImageButton inc1,inc2,dec1,dec2;
    private TextView t1,t2;
    String s1,s2,s3,s4;
    private int m1=0,m2=0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        inc1 = findViewById(R.id.increment1);
        inc2 = findViewById(R.id.increment2);
        dec1 = findViewById(R.id.decrement1);
        dec2 = findViewById(R.id.decrement2);
        t1 = findViewById(R.id.score1);
        t2 = findViewById(R.id.score2);
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
}
