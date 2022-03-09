package com.example.autowiringmutiple;

import org.springframework.stereotype.Component;

@Component
public class Impl2 implements MyComponent{

    @Override
    public void act() {
        System.out.println(this.toString());
    }
}
