/*
 * Copyright 2021 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


namespace RelLib/Relation {

    pub def whenTrue(test: Bool, reln: #{| r}): #{| r} = match test {
        case true => reln
        case _ => #{}
    }

    pub def whenFalse(test: Bool, reln: #{| r}): #{| r} = match test {
        case false => reln
        case _ => #{}
    }

    pub def guard(x: a, test: a -> Bool, f: a -> #{| r}): #{| r} = match test(x) {
        case true => f(x)
        case _ => #{}
    }

    pub def guard2(x: a, y: b, test: (a, b) -> Bool, f: (a, b) -> #{| r}): #{| r} = match test(x, y) {
        case true => f(x, y)
        case _ => #{}
    }

    pub def guard3(x: a, y: b, z: c, test: (a, b, c) -> Bool, f: (a, b, c) -> #{| r}): #{| r} = match test(x, y, z) {
        case true => f(x, y, z)
        case _ => #{}
    }

    pub def optional(x: Option[#{| r}]): #{| r} = match x {
        case Some(r1) => r1
        case _ => #{}
    }


    pub def combineAll(relns: t[#{| r}]): #{| r} with Foldable[t] =
        Foldable.foldLeft((ac, x) -> ac <+> x, #{}, relns)

    pub def unfold(f: s -> Option[(#{| r}, s)] & ef, st: s): #{| r} & ef = unfoldHelper(f, st, #{})

    ///
    /// Helper function for `unfold`.
    ///
    def unfoldHelper(f: s -> Option[(#{| r}, s)] & ef, st: s, ac: #{| r}): #{| r} & ef = match f(st) {
        case None => ac
        case Some(a, st1) => {let ac1 = ac <+> a; unfoldHelper(f, st1, ac1)}
    }

    ///
    /// Returns the result of mapping each element and combining the results.
    ///
    pub def foldMap(f: a -> #{| r} & ef, t: t[a]): #{| r} & ef with Foldable[t] =
        Foldable.foldLeft((acc, x) -> acc <+> f(x), #{}, t)

    ///
    /// Returns the result of mapping each element and combining the results.
    ///
    pub def foldMapWithIndex(f: (a, Int32) -> #{| r} & ef, t: t[a]): #{| r} & ef with Foldable[t] =
        Foldable.foldLeft((acc, x) -> {let (r1, i) = acc; (r1 <+> f(x, i), i + 1)}, (#{}, 0), t) |> fst

    ///
    /// Returns the result of mapping each element and combining the results.
    ///
    pub def foldMapResult(f: a -> Result[#{| r}, e] & ef, xs: List[a]): Result[#{| r}, e] & ef =
        foldMapResultHelper(f, xs, e -> Err(e), r1 -> Ok(r1))

    def foldMapResultHelper(f: a -> Result[#{| r}, e] & ef,
                        xs: List[a],
                        fk: e -> Result[#{| r}, e],
                        sk: #{| r} -> Result[#{| r}, e]): Result[#{| r}, e] & ef = match xs {
        case Nil => sk(#{})
        case x :: rs => match f(x) {
            case Ok(r1) => foldMapResultHelper(f, rs, fk, ac -> sk(ac <+> r1))
            case Err(e) => fk(e)
        }
    }

}