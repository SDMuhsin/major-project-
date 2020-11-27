%subfunction for making AR4JA H matrix
%Theta table from CCSDS document.

%theta table functions
    function num2 = theta(kval)
        a11 = [1 3 1 59 16 160 108 226 1148 0 0 0 0 0 0 0
2 0 22 18 103 241 126 618 2032 27 32 53 182 375 767 1822
3 1 0 52 105 185 238 404 249 30 21 74 249 436 227 203
4 2 26 23 0 251 481 32 1807 28 36 45 65 350 247 882
5 2 0 11 50 209 96 912 485 7 30 47 70 260 284 1989
6 3 10 7 29 103 28 950 1044 1 29 0 141 84 370 957
7 0 5 22 115 90 59 534 717 8 44 59 237 318 482 1705
8 1 18 25 30 184 225 63 873 20 29 102 77 382 273 1083
9 0 3 27 92 248 323 971 364 26 39 25 55 169 886 1072
10 1 22 30 78 12 28 304 1926 24 14 3 12 213 634 354
11 2 3 43 70 111 386 409 1241 4 22 88 227 67 762 1942
12 0 8 14 66 66 305 708 1769 12 15 65 42 313 184 446
13 2 25 46 39 173 34 719 532 23 48 62 52 242 696 1456
14 3 25 62 84 42 510 176 768 15 55 68 243 188 413 1940
15 0 2 44 79 157 147 743 1138 15 39 91 179 1 854 1660
16 1 27 12 70 174 199 759 965 22 11 70 250 306 544 1661
17 2 7 38 29 104 347 674 141 31 1 115 247 397 864 587
18 0 7 47 32 144 391 958 1527 3 50 31 164 80 82 708
19 1 15 1 45 43 165 984 505 29 40 121 17 33 1009 1466
20 2 10 52 113 181 414 11 1312 21 62 45 31 7 437 433
21 0 4 61 86 250 97 413 1840 2 27 56 149 447 36 1345
22 1 19 10 1 202 158 925 709 5 38 54 105 336 562 867
23 2 7 55 42 68 86 687 1427 11 40 108 183 424 816 1551
24 1 9 7 118 177 168 752 989 26 15 14 153 134 452 2041
25 2 26 12 33 170 506 867 1925 9 11 30 177 152 290 1383
26 3 17 2 126 89 489 323 270 17 18 116 19 492 778 1790];
        num2 = a11(kval,2);
    end%function