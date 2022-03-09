package com.example.autowiringmutiple;

import org.springframework.stereotype.Component;

@Component
public class Impl1 implements MyComponent{

    @Override
    public void act() {
        System.out.println(this.toString());
    }
}
