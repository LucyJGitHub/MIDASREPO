      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. JMI106 *CREATE     Date 24May18               *
      *  Prev Amend No. nnnnnn             Date ddmmmnn               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           (Upgrade to FB Midas)                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                                                       JMI106
     D DATA2           DS          1024                                                       JMI106
     D   UPSEQ                 1      5                                                       JMI106
     D   DPSTMT                6      7  0                                                    JMI106
     D   DPSEQ                 8     11                                                       JMI106
      *                                                                                       JMI106
     D DATA3           DS          1024                                                       JMI106
     D   WDP32B                      42A                                                      JMI106
      *                                                                                       JMI106
     D DATAI           DS            99                                                       JMI106
     D   DIN01                 1      1                                                       JMI106
     D   DIN02                 2      2                                                       JMI106
     D   DIN03                 3      3                                                       JMI106
     D   DIN04                 4      4                                                       JMI106
     D   DIN05                 5      5                                                       JMI106
     D   DIN06                 6      6                                                       JMI106
     D   DIN07                 7      7                                                       JMI106
     D   DIN08                 8      8                                                       JMI106
     D   DIN09                 9      9                                                       JMI106
     D   DIN10                10     10                                                       JMI106
     D   DIN11                11     11                                                       JMI106
     D   DIN12                12     12                                                       JMI106
     D   DIN13                13     13                                                       JMI106
     D   DIN14                14     14                                                       JMI106
     D   DIN15                15     15                                                       JMI106
     D   DIN16                16     16                                                       JMI106
     D   DIN17                17     17                                                       JMI106
     D   DIN18                18     18                                                       JMI106
     D   DIN19                19     19                                                       JMI106
     D   DIN20                20     20                                                       JMI106
     D   DIN21                21     21                                                       JMI106
     D   DIN22                22     22                                                       JMI106
     D   DIN23                23     23                                                       JMI106
     D   DIN24                24     24                                                       JMI106
     D   DIN25                25     25                                                       JMI106
     D   DIN26                26     26                                                       JMI106
     D   DIN27                27     27                                                       JMI106
     D   DIN28                28     28                                                       JMI106
     D   DIN29                29     29                                                       JMI106
     D   DIN30                30     30                                                       JMI106
     D   DIN31                31     31                                                       JMI106
     D   DIN32                32     32                                                       JMI106
     D   DIN33                33     33                                                       JMI106
     D   DIN34                34     34                                                       JMI106
     D   DIN35                35     35                                                       JMI106
     D   DIN36                36     36                                                       JMI106
     D   DIN37                37     37                                                       JMI106
     D   DIN38                38     38                                                       JMI106
     D   DIN39                39     39                                                       JMI106
     D   DIN40                40     40                                                       JMI106
     D   DIN41                41     41                                                       JMI106
     D   DIN42                42     42                                                       JMI106
     D   DIN43                43     43                                                       JMI106
     D   DIN44                44     44                                                       JMI106
     D   DIN45                45     45                                                       JMI106
     D   DIN46                46     46                                                       JMI106
     D   DIN47                47     47                                                       JMI106
     D   DIN48                48     48                                                       JMI106
     D   DIN49                49     49                                                       JMI106
     D   DIN50                50     50                                                       JMI106
     D   DIN51                51     51                                                       JMI106
     D   DIN52                52     52                                                       JMI106
     D   DIN53                53     53                                                       JMI106
     D   DIN54                54     54                                                       JMI106
     D   DIN55                55     55                                                       JMI106
     D   DIN56                56     56                                                       JMI106
     D   DIN57                57     57                                                       JMI106
     D   DIN58                58     58                                                       JMI106
     D   DIN59                59     59                                                       JMI106
     D   DIN60                60     60                                                       JMI106
     D   DIN61                61     61                                                       JMI106
     D   DIN62                62     62                                                       JMI106
     D   DIN63                63     63                                                       JMI106
     D   DIN64                64     64                                                       JMI106
     D   DIN65                65     65                                                       JMI106
     D   DIN66                66     66                                                       JMI106
     D   DIN67                67     67                                                       JMI106
     D   DIN68                68     68                                                       JMI106
     D   DIN69                69     69                                                       JMI106
     D   DIN70                70     70                                                       JMI106
     D   DIN71                71     71                                                       JMI106
     D   DIN72                72     72                                                       JMI106
     D   DIN73                73     73                                                       JMI106
     D   DIN74                74     74                                                       JMI106
     D   DIN75                75     75                                                       JMI106
     D   DIN76                76     76                                                       JMI106
     D   DIN77                77     77                                                       JMI106
     D   DIN78                78     78                                                       JMI106
     D   DIN79                79     79                                                       JMI106
     D   DIN80                80     80                                                       JMI106
     D   DIN81                81     81                                                       JMI106
     D   DIN82                82     82                                                       JMI106
     D   DIN83                83     83                                                       JMI106
     D   DIN84                84     84                                                       JMI106
     D   DIN85                85     85                                                       JMI106
     D   DIN86                86     86                                                       JMI106
     D   DIN87                87     87                                                       JMI106
     D   DIN88                88     88                                                       JMI106
     D   DIN89                89     89                                                       JMI106
     D   DIN90                90     90                                                       JMI106
     D   DIN91                91     91                                                       JMI106
     D   DIN92                92     92                                                       JMI106
     D   DIN93                93     93                                                       JMI106
     D   DIN94                94     94                                                       JMI106
     D   DIN95                95     95                                                       JMI106
     D   DIN96                96     96                                                       JMI106
     D   DIN97                97     97                                                       JMI106
     D   DIN98                98     98                                                       JMI106
     D   DIN99                99     99                                                       JMI106
                                                                                              JMI106
     D DATAF1          DS          5000                                                       JMI106
     D   DP32B                       48A                                                      JMI106
     D   DP59                       255A                                                      JMI106
     D   DSTR35                      35A                                                      JMI106
     D DATAF2          DS          5000                                                       JMI106
     D DATAF3          DS          5000                                                       JMI106
     D DATAF4          DS          5000                                                       JMI106
      *                                                                                       JMI106
