package org.apache.jackrabbit.oak;
/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.apache.jackrabbit.oak.jcr.query.QueryTest;
import org.apache.jackrabbit.oak.plugins.index.property.OrderedPropertyIndexDescendingQueryTest;
import org.apache.jackrabbit.oak.plugins.index.property.OrderedPropertyIndexEditorProviderTest;
import org.apache.jackrabbit.oak.plugins.index.property.OrderedPropertyIndexEditorTest;
import org.apache.jackrabbit.oak.plugins.index.property.OrderedPropertyIndexEditorV2Test;
import org.apache.jackrabbit.oak.plugins.index.property.OrderedPropertyIndexQueryTest;
import org.apache.jackrabbit.oak.plugins.index.property.strategy.OrderedContentMirrorStorageStrategyTest;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)
@Suite.SuiteClasses({
    OrderedContentMirrorStorageStrategyTest.class,
    OrderedPropertyIndexQueryTest.class,
    OrderedPropertyIndexDescendingQueryTest.class,
    OrderedPropertyIndexEditorTest.class,
    QueryTest.class,
    OrderedPropertyIndexEditorV2Test.class,
    OrderedPropertyIndexEditorProviderTest.class,
})
public class OrderedIndexAllTests {

}
