      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420OOP1 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC133             Date 01Aug19               *
      *  Prev Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
      * OMITEND
1624 OGL0420P2  E    60 84                    03                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                         LUC108
     O         OR    60 84                    03                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O037
1625 O***********         36   CNA1      35                               S01194
1625 O***********         36   BCCNA1    35                        S01194 LN0012
1625 O                  36   @WCNA1              35                             LN0012
1626 O                  35                       71 'DEMAND STATEMENT'
1627 O*       H   04   61                                                 S01091
1627 O********E** 04   61                                       S01091    S01117
1627 O          E    61 84                    04                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    61 84                    04                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O038
1628 O***********            36CNA2      35                               S01194
1628 O***********            36BCCNA2    35                        S01194 LN0012
1628 O                     36@WCNA2              35                             LN0012
1629 O*       H   05   61                                                 S01091
1629 O********E** 05   61                                       S01091    S01117
1629 O          E    61 84                    05                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    61 84                    05                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O039
1630 O***********            36CNA3      35                               S01194
1630 O***********            36BCCNA3    35                        S01194 LN0012
1630 O                     36@WCNA3              35                             LN0012
1631 O*       H   06   61                                                 S01091
1631 O********E** 06   61                                       S01091    S01117
1631 O          E    61 84                    06                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    61 84                    06                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O040
1632 O***********            36CNA4      35                               S01194
1632 O***********            36BCCNA4    35                        S01194 LN0012
1632 O                     36@WCNA4              35                             LN0012
1633 O*
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP11                                           S01408
     O*                                                                   S01408
1634 O*
1635 O*       H   07   60                                                 S01091
1635 O********E** 07   60                                       S01091    S01117
1635 O          E    60 84                    07                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    60 84                    07                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O041
1636 O* ETC.
1637 O*****                              49 'OUR REF'                     S01117
     O                                           45 'OUR REF'                   S01117
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
1638 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
1639 O                       CNUM                57
1640 O                       CCY                 61
1641 O**********               ACOD      66                                                   CGL029
1642 O**********               ACSQ      69                                                   CGL029
1643 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
1644 O**********                         97 'BRANCH -'                    S01194
1644 O                  58                       97 'BRANCH -'                  S01194
1645 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
1646 O*       H   08   60                                                 S01091
1646 O********E** 08   60                                       S01091    S01117
1646 O******    E    60 84                    08                                S01117       240776A
     O******   AND   27                                                         CGL046       240776A
     O******   OR    60 84                    08                                   AR1014455 240776A
     O******   AND  N27NKL                                                         AR1014455 240776A
     O/COPY WNCPYSRC,GL0420O042
1647 O***********              PAGE  3  128                               S01117
1647 O******                 PAGE2         3    128                             S01117       240776A
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP12                                           S01408
     O*                                                                   S01408
1648 O*       H   10   60                                                 S01091
1648 O********E** 10   60                                       S01091    S01117
1648 O          E    60 84                    10                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    60 84                    10                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O043
1649 O                                           10 'ACCOUNT'
1650 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00369
1651 O                                           48 'CURRENCY'
1652 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O128
1653 O                                           77 'DATE'
1654 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O129
1655 O                                          102 'PAGE'
     O/COPY WNCPYSRC,GL0420OY63                                           S01408
1656 O                       STPA          3    108
     O/COPY WNCPYSRC,GLH00439
     O          E    60 84 05                 11                                CFT004
     O         AND  N79                                                         LUC108
     O                       RIBAN               50                             CFT004
1657 O*       H   13   60                                                 S01091
1657 O********E** 13   60                                       S01091    S01117
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP6                                           S01408
     O*                                                                   S01408
1657 O          E    60 84                    13                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    60 84                    13                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O044
1658 O                                            7 'POSTING'
1659 O                                           16 'VALUE'
1660 O                                           27 'CHEQUE'
1661 O                                           50 'NARRATIVE'
     O/COPY WNCPYSRC,GL0420O107
1662 O                                           76 'DEBITS'
1663 O                                           99 'CREDITS'
1664 O                                          121 'BALANCE'
1665 O*       H   14   60                                                 S01091
1665 O*       E   14   60                                                 S01091
1666 O*                                   6 'DATE'
1667 O*                                  16 'DATE'
1668 O*                                  25 'NO'
1665 O********E** 14   60                                       E10600    S01117
     O/COPY WNCPYSRC,GL0420O070
1665 O          E    60 84                    14                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    60 84                    14                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O045
1666 O                                            6 'DATE'                      E10600
1667 O                                           16 'DATE'                      E10600
1668 O                                           25 'NO'                        E10600
1669 O*       H   16   60                                                 S01091
1669 O********E** 16   60                                       S01091    S01117
     O/COPY WNCPYSRC,GL0420O071
1669 O          E    60 84                    16                                S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    60 84                    16                                           AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O046
1670 O                                           60 'B/F'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP19                                           S01408
     O*                                                                   S01408
1671 O                       LSTDA                8
     O/COPY WNCPYSRC,GL0420O155
1672 O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'
1673 O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'
1674 O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'
1675 O                     73PSTBF              127 '   ,   ,   , 0 .   CR'
1676 O               83                         127 'DR'
     O/COPY WNCPYSRC,GL0420O075
     O**                                                                  CEU013
     O          E    60 84 10            1                                      CEU013
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    60 84 10            1                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CEU013
     O               83                         128 'DR)'                       CEU013
     O**                                                                  CEU013
1677 O***     D 1      41 51N34                                           S01091
     O/COPY WNCPYSRC,GL0420O130
1677 O          E    41 51N34DET         1                                      S01091
     O/COPY WNCPYSRC,GL0420O047
1678 O**     AND       04                                            S1091S01110
1678 O*******AND*      04N12                                    S01110    S01117
1678 O         AND   04N12 84                                                   S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 51N34            1                                                 AR1014455
     O         AND   04N12 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
1679 O                       PSTDA                8
1680 O                     69VALDA               18
1681 O                                           32 'DR'
1682 O                     22                    32 'CR'
1683 O                                           47 'RATE CHANGE TO'
1684 O                       INTR                61 '  0 .       -'
1685 O                                           62 '%'
     O/COPY WNCPYSRC,GL0420O078
1686 O***     D 1      41 51N34                                           S01091
1686 O          E    41 51N34DET         1                                      S01091
1687 O*******AND*     N04                                                 S01117
1687 O         AND  N04 84                                                      S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 51N34            1                                                 AR1014455
     O         AND  N04 84                                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O048
1688 O                       PSTDA                8
1689 O                     69VALDA               18
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP2                                           S01408
     O*                                                                   S01408
1690 O              N25      CHQN                28
1691 O                       PNAR                60
     O/COPY WNCPYSRC,GL0420O146
1692 O                  23 70PSTA                81 ' ,   ,   ,   , 0 '
1693 O                  23 71PSTA                81 '   ,   ,   , 0 . '
1694 O                  23 72PSTA                81 '  ,   ,   , 0 .  '
1695 O                  23 73PSTA                81 ' ,   ,   , 0 .   '
1696 O                  22 70PSTA               103 ' ,   ,   ,   , 0 '
1697 O                  22 71PSTA               103 '   ,   ,   , 0 . '
1698 O                  22 72PSTA               103 '  ,   ,   , 0 .  '
1699 O                  22 73PSTA               103 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O079
1687 O*                                                                   CEU013
     O          E    41 51N34DET         1                                      CEU013
     O         AND  N04 84 78                                                   CEU013
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 51N34            1                                                 AR1014455
     O         AND  N04 84 78                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O                       ROCCY               33                             CEU013
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CEU013
     O          E    41 51N34DET         1                                      216937
     O         AND  N04 84 53                                                   216937
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 51N34            1                                                 AR1014455
     O         AND  N04 84 53                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O                       W#ORIG              70                             216937
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP13                                           S01408
     O*                                                                   S01408
1700 O**   END OF POSTING DATE ONLY
1701 O**
1702 O*       T 00     L1 41 49                                           S01091
1702 O          E    L1 41 49BAL         0  0                                   S01091
1703 O*******AND*     N52N34                                              S01117
1703 O         AND  N52N34 84                                                   S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    L1 41 49            0  0                                              AR1014455
     O         AND  N52N34 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O049
1704 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1705 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1706 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1707 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O156
1708 O                     47                   127 'DR'
1709 O**   END OF PAGE IND 45
1710 O**
1711 O*       T 1         41 45                                           S01091
1711 O          E       41 45ENDPG       1                                      S01091
1712 O*******AND*     N34                                                 S01117
1712 O         AND  N34 84                                                      S01117
     O         AND  N33                                                         S01377
     O/COPY WNCPYSRC,GL0420O050
1713 O*      OR           41 52
1714 O*      AND      N34
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 45               1                                                 AR1014455
     O         AND  N34N33 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
1715 O                                           60 'C/F'
     O/COPY WNCPYSRC,GL0420O157
1716 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1717 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1718 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1719 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O158
1720 O                     47                   127 'DR'
     O**                                                                  CEU013
     O          E       41 45ENDPG       1                                      CEU013
     O         AND  N34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 45 84            1                                                 AR1014455
     O         AND  N34N33 10                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O**                                                                  CEU013
1713 O*       T 1         41 52                                      S1091S01091
1713 O          E       41 52TOT         1                                      S01091
1714 O*******AND*     N34                                       S01091    S01117
1714 O         AND  N34 84                                                      S01117
     O         AND  N33                                                         S01377
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR       41 52            1                                                 AR1014455
     O         AND  N34N33 84                                                              AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O051
1715 O                                           60 'C/F'                       S01091
1716 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     S01091
1717 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    S01091
1718 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    S01091
1719 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O159
1720 O                     47                   127 'DR'                        S01091
     O**                                                                  CEU013
     O          E       41 52TOT         1                                      CEU013
     O         AND  N34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O**                                                                  CEU013
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND  N34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             216006
     O**                                                                  216006
     O/COPY WNCPYSRC,GL0420O036
1721 O**   END OF PAGE ONLY
1722 O**
1723 O*       T 1         41 45                                           S01091
1723 O********E 1         41 45ENDPG                               S01091 E10600
1723 O          E       41 45ENDPG       1  1                                   E10600
1724 O*******AND*     N34                                                 S01117
1724 O         AND  N34 84                                                      S01117
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR    41 45               1  1                                              AR1014455
     O         AND  N34 84                                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O052
1725 O                                          116 '- CONTD'
     O/COPY WNCPYSRC,GL0420OO12                                           S01408
     O********E*1 03           ERPT2                                                   S01117 239641
     O          E            ERPT2       1                                                    239641
     O         AND  N33                                                         S01377
     O         AND   27                                                         CGL046
     O         AND  N79                                                                    LUC108
     O         OR   N33                  1                                                 AR1014455
     O         AND  N27NKL                                                                 AR1014455
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O053
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
1726 O/EJECT
     OGL0420PR  E    60 84                    01                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046
     O         AND  N79                                                                    LUC108
     O                       FICHE               16                             CGL046
      *                                                                   CGL046
     OGL0420PR  E    60 84                    03                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046
     O         AND  N79                                                                    LUC108
     O                  36   @WCNA1              35                             CGL046
     O                  35                       71 'DEMAND STATEMENT'          CGL046
      *       H   04   61                                                 CGL046
     O          E    61 84                    04                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                     36@WCNA2              35                             CGL046
      *       H   05   61                                                 CGL046
     O          E    61 84                    05                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                     36@WCNA3              35                             CGL046
      *       H   06   61                                                 CGL046
     O          E    61 84                    06                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                     36@WCNA4              35                             CGL046
      *                                                                   CGL046
     O          E    60 84                    07                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
      * ETC.                                                              CGL046
     O                                           45 'OUR REF'                   CGL046
     O               58      BRCA                50                             CGL046
     O               58                          51 '-'                         CGL046
     O                                           73 '-   -    -'                CGL046
     O                       CNUM                57                             CGL046
     O                       CCY                 61                             CGL046
     O                       ACOD                72                             CGL046
     O                       ACSQ                75                             CGL046
     O*********       N27 20   ACNO      86                               CGL046            BG12511A
     O              N27      ACNO                86                             CGL046            BG
     O                  58                       97 'BRANCH -'                  CGL046
     O                  58   A8BRNM             128                             CGL046
      *       H   08   60                                                 CGL046
     O          E    60 84                    08                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       PAGE2         3    128                             CGL046
      *                                                                   CGL046
     O          E    60 84                    10                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                           10 'ACCOUNT'                   CGL046
     O                       ANAM                33                             CGL046
     O                                           48 'CURRENCY'                  CGL046
     O                       CCNM                65                             CGL046
     O                                           77 'DATE'                      CGL046
     O                       RUNA                87                             CGL046
     O                                          102 'PAGE'                      CGL046
     O                       STPA          3    108                             CGL046
      *                                                                   CGL046
     O          E    60 84                    13                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                            7 'POSTING'                   CGL046
     O                                           16 'VALUE'                     CGL046
     O                                           27 'CHEQUE'                    CGL046
     O                                           50 'NARRATIVE'                 CGL046
     O                                           76 'DEBITS'                    CGL046
     O                                           99 'CREDITS'                   CGL046
     O                                          121 'BALANCE'                   CGL046
     O          E    60 84                    14                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                            6 'DATE'                      CGL046
     O                                           16 'DATE'                      CGL046
     O                                           25 'NO'                        CGL046
     O          E    60 84                    16                                CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                           60 'B/F'                       CGL046
      *                                                                   CGL046
     O                       LSTDA                8                             CGL046
     O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBF              127 '   ,   ,   , 0 .   CR'     CGL046
     O               83                         127 'DR'                        CGL046
      *                                                                   CGL046
     O          E    60 84 10            1                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                          105 '('                         CGL046
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CGL046
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CGL046
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CGL046
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CGL046
     O               83                         128 'DR)'                       CGL046
      **                                                                  CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND   04N12 84                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       PSTDA                8                             CGL046
     O                     69VALDA               18                             CGL046
     O                                           32 'DR'                        CGL046
     O                     22                    32 'CR'                        CGL046
     O                                           47 'RATE CHANGE TO'            CGL046
     O                       INTR                61 '  0 .       -'             CGL046
     O                                           62 '%'                         CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND  N04 84                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       PSTDA                8                             CGL046
     O                     69VALDA               18                             CGL046
      *                                                                   CGL046
     O              N25      CHQN                28                             CGL046
     O                       PNAR                60                             CGL046
     O                  23 70PSTA                81 ' ,   ,   ,   , 0 '         CGL046
     O                  23 71PSTA                81 '   ,   ,   , 0 . '         CGL046
     O                  23 72PSTA                81 '  ,   ,   , 0 .  '         CGL046
     O                  23 73PSTA                81 ' ,   ,   , 0 .   '         CGL046
     O                  22 70PSTA               103 ' ,   ,   ,   , 0 '         CGL046
     O                  22 71PSTA               103 '   ,   ,   , 0 . '         CGL046
     O                  22 72PSTA               103 '  ,   ,   , 0 .  '         CGL046
     O                  22 73PSTA               103 ' ,   ,   , 0 .   '         CGL046
      *                                                                   CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND  N04 84 78                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       ROCCY               33                             CGL046
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CGL046
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CGL046
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CGL046
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CGL046
     O          E    41 51N34DET         1                                      CGL046
     O         AND  N04 84 53                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       W#ORIG              70                             CGL046
      *                                                                   CGL046
      **   END OF POSTING DATE ONLY                                       CGL046
     O          E    L1 41 49BAL         0  0                                   CGL046
     O         AND  N52N34 84                                                   CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     CGL046
     O                     47                   127 'DR'                        CGL046
      *    END OF PAGE IND 45                                             CGL046
      *                                                                   CGL046
      *       T 1         41 45                                           CGL046
     O          E       41 45ENDPG       1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33                                                         CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                           60 'C/F'                       CGL046
     O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     CGL046
     O                     47                   127 'DR'                        CGL046
      *                                                                   CGL046
     O          E       41 45ENDPG       1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 10                                                      CGL046
     O         AND   27                                                         CGL046
      * Can only write if file is OPEN                                                      BG12511A
     O         AND   KL                                                                     BG12511A
     O         AND  N79                                                                    LUC108
     O                                          105 '('                         CGL046
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CGL046
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CGL046
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CGL046
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CGL046
     O                     47                   128 'DR)'                       CGL046
      *                                                                   CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33                                                         CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                           60 'C/F'                       CGL046
     O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     CGL046
     O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    CGL046
     O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    CGL046
     O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     CGL046
     O                     47                   127 'DR'                        CGL046
      *                                                                   CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 10                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                          105 '('                         CGL046
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CGL046
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CGL046
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CGL046
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CGL046
     O                     47                   128 'DR)'                       CGL046
      *                                                                   CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             CGL046
     O          E       41 52TOT         1                                      CGL046
     O         AND  N34 84                                                      CGL046
     O         AND  N33 82                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             CGL046
      *                                                                   CGL046
      *    END OF PAGE ONLY                                               CGL046
      *                                                                   CGL046
     O          E       41 45ENDPG       1  1                                   CGL046
     O         AND  N34 84                                                      CGL046
     O*******AND      N27 20                                              CGL046            BG12511A
     O         AND  N27 KL                                                      CGL046            BG
     O         AND  N79                                                                    LUC108
     O                                          116 '- CONTD'                   CGL046
     O          E            ERPT2       1    03                                CGL046
     O         AND  N33                                                         CGL046
     O*******AND      N27 20                                                          CGL046 BG12511
     O         AND  N27 KL                                                                   BG12511
     O         AND  N79                                                                    LUC108
     O                                           66 '*** END OF REPORT '        CGL046
     O               58                          77 'FOR BRANCH '               CGL046
     O               58      BRCASV              80                             CGL046
     O               58                          84 ' ***'                      CGL046
     O              N58                          69 '***'                       CGL046
     O/EJECT                                                              CGL046
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OO13                                           S01408
     O*                                                                   S01408
1727 O*****MPRINTS2**BEGINS**H*E*R*E***                                   S01125
1727 O*    GL0420P3  BEGINS  H E R E                                      S01125
1728 O*                      -------
1729 O*PRINTS2H   03   62                                                 S01091
1729 O*PRINTS2E   03   62                                                 S01125
1624 O*L0420P3E   03   62                                                 S01146
1624 O*L0420P3E** 01   62                                          S01146 S01117
1624 OGL0420P3  E    62 84                    01                                S01117
     O         AND  N79                                                         LUC108
     O                       FICHE               16                             S01146
     O********E** 03   62                                          S01146 S01117
     O          E    62 84                    03                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O003
1730 O***********         36   CNA1      35                               S01194
     O/COPY WNCPYSRC,GL0420O004
1730 O***********         36   BCCNA1    35                         S01194BHF093
1730 O                  36   @WCNA1              35                             BHF093
1731 O                  35                       71 'DEMAND STATEMENT'
1732 O*       H   04   63                                                 S01091
1732 O********E** 04   63                                       S01091    S01117
1732 O          E    63 84                    04                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O005
1733 O***********            36CNA2      35                               S01194
     O/COPY WNCPYSRC,GL0420O006
1733 O***********            36BCCNA2    35                         S01194BHF093
1733 O                     36@WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O097
1734 O*       H   05   63                                                 S01091
1734 O********E** 05   63                                       S01091    S01117
1734 O          E    63 84                    05                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O007
1735 O***********            36CNA3      35                               S01194
     O/COPY WNCPYSRC,GL0420O008
1735 O***********            36BCCNA3    35                         S01194BHF093
1735 O                     36@WCNA3              35                             BHF093
1736 O*       H   06   63                                                 S01091
1736 O********E** 06   63                                       S01091    S01117
1736 O          E    63 84                    06                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O009
1737 O***********            36CNA4      35                               S01194
     O/COPY WNCPYSRC,GL0420O010
1737 O***********            36BCCNA4    35                         S01194BHF093
1737 O                     36@WCNA4              35                             BHF093
1738 O*       H   07   62                                                 S01091
1738 O********E** 07   62                                       S01091    S01117
1738 O          E    62 84                    07                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O011
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
1739 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
     O/COPY WNCPYSRC,GL0420O012                                           S01408
1740 O                       CNUM                57
1741 O                       CCY                 61
1742 O**********               ACOD      66                                                   CGL029
1743 O**********               ACSQ      69                                                   CGL029
1744 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
     O*CO*Y*WN*PY*RC*GL0420O012                                           S01408
     O/COPY WNCPYSRC,GL0420O013                                           S01408
1745 O***********                        97 'BRANCH -'                    S01194
     O/COPY WNCPYSRC,GL0420O014
1745 O                  58                       97 'BRANCH -'                  S01194
     **C*PY*WN*PY**C*GL0420O013                                           S01408
     O/COPY WNCPYSRC,GL0420OY13                                           S01408
1746 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
     O/COPY WNCPYSRC,GL0420Y054                                           S01408
1747 O*       H   08   62                                                 S01091
1747 O********E** 08   62                                       S01091    S01117
1747 O******    E    62 84                    08                                S01117       240776A
     O*CO*Y*WN*PY*RC*GL0420O014                                           S01408
     O/COPY WNCPYSRC,GL0420O015                                           S01408
1748 O***********              PAGE  3  128                               S01117
     **C*PY*WN*PY*RC*GL0420O015                                           S01408
     O/COPY WNCPYSRC,GL0420O016                                           S01408
1748 O******                 PAGE3         3    128                             S01117       240776A
     O/COPY WNCPYSRC,GL0420O054
1749 O*       H   10   62                                                 S01091
1749 O********E** 10   62                                       S01091    S01117
     **C*PY*WN*PY*RC*GL0420O016                                           S01408
1749 O          E    62 84                    10                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O017
1750 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00370
1751 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O131
1752 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O055
1753 O                       STPA          3    108
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP7                                           S01408
     O*                                                                   S01408
1754 O*       H   16   62                                                 S01091
1754 O********E** 16   62                                       S01091    S01117
1754 O          E    62 84                    16                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O018
1755 O                                           60 'B/F'
     O/COPY WNCPYSRC,GL0420O019
1756 O                       LSTDA                8
     O/COPY WNCPYSRC,GL0420O056
1757 O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'
     **C*PY*WN*PY*RC*GL0420O057                                           S01408
     O/COPY WNCPYSRC,GL0420OY57                                           S01408
1758 O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'
1759 O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'
1760 O                     73PSTBF              127 '   ,   ,   , 0 .   CR'
1761 O               83                         127 'DR'
     O/COPY WNCPYSRC,GL0420O080
     O**                                                                  CEU013
     O          E    62 84 10                 17                                CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CEU013
     O               83                         128 'DR)'                       CEU013
     O**                                                                  CEU013
     **C*PY*WN*PY*RC*GL0420O019                                           S01408
     O/COPY WNCPYSRC,GL0420O020                                           S01408
1762 O***     D 1      51 42 04                                           S01091
     **C*PY*WN*PY*RC*GL0420O020                                           S01408
1762 O          E    51 42 04DET         1                                      S01091
     O/COPY WNCPYSRC,GL0420O021
     O*******AND*     N12                                       S01110    S01117
     O/COPY WNCPYSRC,GL0420O022
     O         AND  N12 84                                                      S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O023
1763 O                       PSTDA                8
     O/COPY WNCPYSRC,GL0420O024
1764 O                     69VALDA               18
1765 O                                           32 'DR'
1766 O                     22                    32 'CR'
1767 O                                           47 'RATE CHANGE TO'
1768 O                       INTR                61 '  0 .       -'
1769 O                                           62 '%'
     O/COPY WNCPYSRC,GL0420O081
     O*C*PY*WN*PY*RC*GL0420O023                                           S01408
1770 O***     D 1      51 42N04                                           S01091
     O*C*PY*WN*PY*RC*GL0420O024                                           S01408
1770 O          E    51 42N04DET         1                                      S01091
     O/COPY WNCPYSRC,GL0420O025
     O         AND   84                                                         S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O118
1771 O                       PSTDA                8
     O/COPY WNCPYSRC,GL0420O026
1772 O                     69VALDA               18
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP3                                           S01408
     O*                                                                   S01408
1773 O              N25      CHQN                28
     **C*PY*WN*PY*RC*GL0420O058                                           S01408
     O/COPY WNCPYSRC,GL0420O057
1774 O                       PNAR                60
     **C*PY*WN*PY*RC*GL0420O059                                           S01408
     O/COPY WNCPYSRC,GL0420O058
1775 O                  23 70PSTA                81 ' ,   ,   ,   , 0 '
1776 O                  23 71PSTA                81 '   ,   ,   , 0 . '
1777 O                  23 72PSTA                81 '  ,   ,   , 0 .  '
1778 O                  23 73PSTA                81 ' ,   ,   , 0 .   '
     **C*PY*WN*PY*RC*GL0420O060                                           S01408
     O/COPY WNCPYSRC,GL0420O059                                           S01408
1779 O                  22 70PSTA               103 ' ,   ,   ,   , 0 '
1780 O                  22 71PSTA               103 '   ,   ,   , 0 . '
1781 O                  22 72PSTA               103 '  ,   ,   , 0 .  '
1782 O                  22 73PSTA               103 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O082
     O*                                                                   CEU013
     O          E    51 42N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       ROCCY               33                             CEU013
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    51 42N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O         AND  N79                                                                    LUC108
     O                       W#ORIG              70                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP14                                           S01408
     O*                                                                   S01408
1783 O**   END OF POSTING DATE ONLY
1784 O**
1785 O*       T 00     L1 42 49                                           S01091
1785 O          E    L1 42 49BAL         0  0                                   S01091
     **C*PY*WN*PY*RC*GL0420O025                                           S01408
     O/COPY WNCPYSRC,GL0420OY25                                           S01408
1786 O*******AND*     N52                                                 S01117
     **C*PY*WN*PY*RC*GL0420O026                                           S01408
     O/COPY WNCPYSRC,GL0420OY26                                           S01408
1786 O         AND  N52 84                                                      S01117
     O         AND  N79                                                                    LUC108
     **C*PY*WN*PY*RC*GL0420O027                                           S01408
     O/COPY WNCPYSRC,GL0420O060                                           S01408
1787 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1788 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1789 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1790 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
1791 O                     47                   127 'DR'
     **C*PY*WN*PY*RC*GL0420O028                                           S01408
     O/COPY WNCPYSRC,GL0420O027                                           S01408
1792 O**   END OF PAGE IND 45
1793 O**
1794 O********E*1         42 45ENDPG                            S01091    S01117
     **C*PY*WN*PY*RC*GL0420O029                                           S01408
1794 O          E    84 42 45ENDPG       1                                      S01117
     **C*PY*WN*PY*RC*GL0420O030                                           S01408
     O/COPY WNCPYSRC,GL0420O028                                           S01408
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
1794 O*       T 1         42 45                                           S01091
1795 O*      OR           42 52                                           S01091
     O/COPY WNCPYSRC,GL0420OX61                                           S01408
1796 O                                           60 'C/F'
     O/COPY WNCPYSRC,GL0420O061
1797 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
1798 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
1799 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
1800 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
1801 O                     47                   127 'DR'
     O/COPY WNCPYSRC,GL0420O119
     O**                                                                  CEU013
     O          E    84 42 45ENDPG       1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O**                                                                  CEU013
     **C*PY*WN*PY*RC*GL0420O031                                           S01408
     O/COPY WNCPYSRC,GL0420O029                                           S01408
1795 O*       T 1         42 52                                      S1091S01091
1795 O********E*1         42 52TOT                              S01091    S01117
1795 O          E    84 42 52TOT         1                                      S01117
     **C*PY*WN*PY*RC*GL0420O032                                           S01408
     O/COPY WNCPYSRC,GL0420O030                                           S01408
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
     O*C*PY*WN*PY*RC*GL0420O033                                           S01408
     O/COPY WNCPYSRC,GL0420O120
1796 O                                           60 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O062
1797 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     S01091
1798 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    S01091
1799 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    S01091
1800 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     S01091
1801 O                     47                   127 'DR'                        S01091
     O/COPY WNCPYSRC,GL0420O121
     O**                                                                  CEU013
     O          E    84 42 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O*                                                                   216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             216006
     O          E    84 42 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             216006
     O**                                                                  CEU013
     O*C*PY*WN*PY*RC*GL0420O034                                           S01408
     O/COPY WNCPYSRC,GL0420O031                                           S01408
1802 O**   END OF PAGE ONLY
1803 O**
1804 O*       T 1         42 45ENDPG                                      S01091
1804 O******  E 1         42 45                                    S01091 E10600
1804 O********E*1         42 45ENDPG                            E10600    S01117
1804 O          E    84 42 45ENDPG       1                                      S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O032
1805 O                                          116 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP20                                           S01408
     O*                                                                   S01408
     O********E*1 03           ERPT3                                                   S01117 239641
     O          E            ERPT3       1                                                    239641
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP3                                            S01408
     O*                                                                   S01408
1806 O/EJECT
     O/COPY WNCPYSRC,GL0420O063
1807 O*****MPRINTS3BEGINS****H*E*R*E***                                   S01125
1807 O*    GL0420P4BEGINS    H E R E                                      S01125
1808 O*                      -------
1809 O*
1810 O*PRINTS3H   02   64                                                 S01091
1810 O*PRINTS3E   02   64                                                 S01125
1624 O*L0420P4E   03   64                                                 S01146
1624 O*L0420P4E** 01   64                                          S01146 S01117
     O/COPY WNCPYSRC,GL0420O035
1810 OGL0420P4  E    64 84                    01                                S01117
     O         AND  N79                                                         LUC108
     O                       FICHE               16                             S01146
     O/COPY WNCPYSRC,GL0420O076
     O********E** 03   64                                          S01146 S01117
     O          E    64 84                    03                                S01117
     O         AND  N79                                                         LUC108
1811 O*****                              31 '-   -    -'                  S01117
1812 O*****                    CNUM      21                               S01117
1813 O*****                    CCY       25                               S01117
1814 O*****                    ACOD      30                               S01117
1815 O*****                    ACSQ      33                               S01117
1816 O*****           N27      ACNO      45                               S01117
     O               58      BRCA                18                             S01117
     O               58                          19 '-'                         S01117
     O**********                         35 '-   -    -'                               S01117 CGL029
     O**********                         41 '-   -    -'                               CGL029 245223
     O                                           26 '-'                                       245223
     O                                           30 '-'                                       245223
     O                                           41 '-'                                       245223
     O                       CNUM                25                             S01117
     O                       CCY                 29                             S01117
     O**********               ACOD      34                                            S01117 CGL029
     O**********               ACSQ      37                                            S01117 CGL029
     O**********      N27      ACNO      49                                            S01117 CGL029
     O                       ACOD                40                                           CGL029
     O                       ACSQ                43                                           CGL029
     O              N27      ACNO                55                                           CGL029
1817 O                  35                       74 'DEMAND STATEMENT'
1818 O*       H   04   65                                                 S01091
1818 O********E** 04   65                                       S01091    S01117
1818 O          E    65 84                    04                                S01117
     O         AND  N79                                                                    LUC108
1819 O***********            36CNA1      50                               S01194
1819 O***********            36BCCNA1    50                         S01194BHF093
1819 O                     36@WCNA1              50                             BHF093
1820 O*       H   05   65                                                 S01091
1820 O********E** 05   65                                       S01091    S01117
1820 O          E    65 84                    05                                S01117
     O         AND  N79                                                                    LUC108
1821 O***********            36CNA2      50                               S01194
1821 O***********            36BCCNA2    50                         S01194BHF093
1821 O                     36@WCNA2              50                             BHF093
     O/COPY WNCPYSRC,GL0420O098
1822 O*       H   06   65                                                 S01091
1822 O********E** 06   65                                       S01091    S01117
1822 O          E    65 84                    06                                S01117
     O         AND  N79                                                           LUC108
1823 O***********            36CNA3      50                               S01194
1823 O***********            36BCCNA3    50                         S01194BHF093
1823 O                     36@WCNA3              50                             BHF093
1824 O*       H   07   65                                                 S01091
1824 O********E** 07   65                                       S01091    S01117
1824 O          E    65 84                    07                                S01117
     O         AND  N79                                                         LUC108
1825 O***********            36CNA4      50                               S01194
1825 O***********            36BCCNA4    50                         S01194BHF093
1825 O                     36@WCNA4              50                             BHF093
1826 O*       H        64 36                                              S01091
1826 O*       E        64 36                                              S01091
1827 O*      OR   07   64N36                                              S01125
1826 O********E** 07   64 36                                    S01125    S01117
1827 O*******OR**      64N36                                    S01125    S01117
1826 O          E    64 36 84                 08                                S01117
     O         AND  N79                                                         LUC108
1827 O         OR    64N36 84                                                   S01117
     O         AND  N79                                                         LUC108
1828 O***********                        68 'BRANCH -'                    S01194
1828 O                  58                       68 'BRANCH -'                  S01194
1829 O***********              BRNM      99                               S01194
     O                  58   A8BRNM              99                             S01194
1830 O*       H   08   64                                                 S01091
1830 O********E** 08   64                                       S01091    S01117
1830 O********E***08   64 84                                    S01117    E30556
1830 O******    E    64 84                    09                                E30556       240776A
1831 O***********              PAGE  3   99                               S01117
1831 O******                 PAGE4         3     99                             S01117       240776A
1832 O*       H   10   64                                                 S01091
1832 O********E** 10   64                                       S01091    S01117
1832 O          E    64 84                    10                                S01117
     O         AND  N79                                                         LUC108
     O/COPY WNCPYSRC,GLH00371
1833 O                                           20 'ACCOUNT'
1834 O                       ANAM                43
     O/COPY WNCPYSRC,GL0420O132
1835 O                                           52 'CCY'
1836 O                       CCNM                68
1837 O                                           75 'DATE'
1838 O                       RUNA                85
     O/COPY WNCPYSRC,GL0420O133
1839 O                                           93 'PAGE'
     O/COPY WNCPYSRC,GL0420O064
1840 O                       STPA          3     98
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP8                                           S01408
     O*                                                                   S01408
1841 O*       H   13   64                                                 S01091
1841 O********E** 13   64                                       S01091    S01117
1841 O          E    64 84                    13                                S01117
     O         AND  N79                                                         LUC108
     O
1842 O                                           21 'DATE'
1843 O                                           44 'NARRATIVE'
     O/COPY WNCPYSRC,GL0420O108
1844 O                                           71 'AMOUNT'
1845 O                                           93 'BALANCE'
     O/COPY WNCPYSRC,GL0420O123
1846 O*       H   16   64                                                 S01091
1846 O********E** 16   64                                       S01091    S01117
1846 O          E    64 84                    16                                S01117
     O         AND  N79                                                         LUC108
     O/COPY WNCPYSRC,GL0420O077
1847 O                                           55 'B/F'
1848 O                       LSTDA               23
     O/COPY WNCPYSRC,GL0420O160
1849 O                     70PSTBF              100 '   ,   ,   ,   , 0 CR'
1850 O                     71PSTBF              100 '  ,   ,   ,   , 0 . CR'
1851 O                     72PSTBF              100 ' ,   ,   ,   , 0 .  CR'
1852 O                     73PSTBF              100 '   ,   ,   , 0 .   CR'
1853 O               83                         100 'DR'
     O/COPY WNCPYSRC,GL0420O083
     O*                                                                   CEU013
     O          E    64 84 10                 17                                CEU013
     O         AND  N79                                                         LUC108
     O                       BKEURO              60                             156327
     O                                           77 '('                         156327
     O                     KAEUPBF              100 '   ,   ,   ,   , 0 CR)'    156327
     O                     KBEUPBF              100 '  ,   ,   ,   , 0 . CR)'   156327
     O                     KCEUPBF              100 ' ,   ,   ,   , 0 .  CR)'   156327
     O                     KDEUPBF              100 '   ,   ,   , 0 .   CR)'    156327
     O               83                         100 'DR)'                       156327
     O**********                         78 '('                    CEU013*156327
     O**********             KAEUPBF  101 '   ,   ,   ,   , 0 CR)' CEU013*156327
     O**********             KBEUPBF  101 '  ,   ,   ,   , 0 . CR)'CEU013*156327
     O**********             KCEUPBF  101 ' ,   ,   ,   , 0 .  CR)'CEU013*156327
     O**********             KDEUPBF  101 '   ,   ,   , 0 .   CR)' CEU013*156327
     O**********       83               101 'DR)'                  CEU013*156327
     O*                                                                   CEU013
1854 O*
1855 O***     D 1      43 51 04                                           S01091
     O/COPY WNCPYSRC,GL0420O134
1855 O          E    43 51 04DET         1                                      S01091
     O*******AND*     N12                                       S01110    S01117
     O         AND  N12 84                                                      S01117
     O         AND  N79                                                         LUC108
1856 O                       PSTDA               23
1857 O                                           27 'DR'
1858 O                     22                    27 'CR'
1859 O                                           42 'RATE CHANGE TO'
1860 O                       INTR                56 '  0 .       -'
1861 O                                           57 '%'
     O/COPY WNCPYSRC,GL0420O084
1862 O***     D 1      43 51N04                                           S01091
1862 O          E    43 51N04DET         1                                      S01091
     O         AND   84                                                         S01117
     O         AND  N79                                                         LUC108
1863 O                       PSTDA               23
1864 O                       PNAR                55
     O/COPY WNCPYSRC,GL0420O147
1865 O                     70PSTA                74 ' ,   ,   ,   , 0 '
1866 O                     71PSTA                74 '   ,   ,   , 0 . '
1867 O                     72PSTA                74 '  ,   ,   , 0 .  '
1868 O                     73PSTA                74 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O148
1869 O                                           76 'DR'
1870 O                     22                    76 'CR'
     O/COPY WNCPYSRC,GL0420O085
     O*                                                                   CEU013
     O          E    43 51N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O         AND  N79                                                         LUC108
     O                       ROCCY               28                             CEU013
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               49 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    43 51N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O         AND  N79                                                         LUC108
     O                       W#ORIG              65                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP15                                           S01408
     O*                                                                   S01408
1871 O**   END OF POSTING DATE ONLY
1872 O**
1873 O*       T 00     L1 43 49                                           S01091
1873 O          E    L1 43 49BAL         0  0                                   S01091
1874 O*******AND*     N52                                                 S01117
1874 O         AND  N52 84                                                      S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O161
1875 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1876 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1877 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1878 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O162
1879 O                     47                   100 'DR'
     O/COPY WNCPYSRC,GL0420O144
1880 O**   END OF PAGE IND 45
1881 O**
1882 O          E       43 45ENDPG       1                                      S01091
1874 O         AND   84                                                         S01117
     O         AND  N33                                                         S01377
     O         AND  N79                                                         LUC108
1882 O*       T 1         43 45                                           S01091
1883 O*      OR           43 52
1884 O                                           55 'C/F'
     O/COPY WNCPYSRC,GL0420O163
1885 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1886 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1887 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1888 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O164
1889 O                     47                   100 'DR'
     O*                                                                   CEU013
      *
     O          E       43 45ENDPG       1                                      CEU013
     O         AND   84                                                         CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                         LUC108
     O                       BKEURO              60                             156327
     O                                           77 '('                         156327
     O                     KAEUPBAL             100 '   ,   ,   ,   , 0 CR)'    156327
     O                     KBEUPBAL             100 '  ,   ,   ,   , 0 . CR)'   156327
     O                     KCEUPBAL             100 ' ,   ,   ,   , 0 .  CR)'   156327
     O                     KDEUPBAL             100 '   ,   ,   , 0 .   CR)'    156327
     O               47                         100 'DR)'                       156327
     O**********                         78 '('                    CEU013*156327
     O**********             KAEUPBAL 101 '   ,   ,   ,   , 0 CR)' CEU013*156327
     O**********             KBEUPBAL 101 '  ,   ,   ,   , 0 . CR)'CEU013*156327
     O**********             KCEUPBAL 101 ' ,   ,   ,   , 0 .  CR)'CEU013*156327
     O**********             KDEUPBAL 101 '   ,   ,   , 0 .   CR)' CEU013*156327
     O**********       47               101 'DR)'                  CEU013*156327
     O*                                                                   CEU013
1883 O*       T 1         43 52                                      S1091S01091
1883 O********E*1         43 52TOT                              S01091    S01117
1883 O          E    84 43 52TOT         1                                      S01117
     O         AND  N33                                                         S01377
     O         AND  N79                                                         LUC108
1884 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O165
1885 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'     S01091
1886 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'    S01091
1887 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'    S01091
1888 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O166
1889 O                     47                   100 'DR'                        S01091
      *
     O*                                                                   CEU013
     O          E    84 43 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                         LUC108
     O                       BKEURO              60                             156327
     O                                           77 '('                         156327
     O                     KAEUPBAL             100 '   ,   ,   ,   , 0 CR)'    156327
     O                     KBEUPBAL             100 '  ,   ,   ,   , 0 . CR)'   156327
     O                     KCEUPBAL             100 ' ,   ,   ,   , 0 .  CR)'   156327
     O                     KDEUPBAL             100 '   ,   ,   , 0 .   CR)'    156327
     O               47                         100 'DR)'                       156327
     O*                                                                   216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             216006
     O          E    84 43 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O103
     O**********                         78 '('                    CEU013*156327
     O**********             KAEUPBAL 101 '   ,   ,   ,   , 0 CR)' CEU013*156327
     O**********             KBEUPBAL 101 '  ,   ,   ,   , 0 . CR)'CEU013*156327
     O**********             KCEUPBAL 101 ' ,   ,   ,   , 0 .  CR)'CEU013*156327
     O**********             KDEUPBAL 101 '   ,   ,   , 0 .   CR)' CEU013*156327
     O**********       47               101 'DR)'                  CEU013*156327
     O*                                                                   CEU013
1897 O**   END OF PAGE ONLY
1898 O**
1899 O*       T 1         43 45                                           S01091
1899 O********E*1         43 45ENDPG                            S01091    S01117
1899 O          E    84 43 45ENDPG       1                                      S01117
     O         AND  N79                                                         LUC108
     O                                           85 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP21                                           S01408
     O*                                                                   S01408
     O********E*1 03           ERPT4                                                   S01117 239641
     O          E            ERPT4       1                                                    239641
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
     O/COPY WNCPYSRC,GL0420O002
1901 O/EJECT
1902 O*****MPRINTS4BEGINS****H*E*R*E****                                  S01125
1902 O*    GL0420P5BEGINS    H E R E                                      S01125
1903 O*                      -------
1904 O*
1905 O*PRINTS4H   02   66                                                 S01091
1905 O*PRINTS4E   02   66                                                 S01125
1624 O*L0420P5E   02   66                                                 S01146
1624 O*L0420P5E** 01   66                                          S01146 S01117
     O/COPY WNCPYSRC,GL0420O145
1905 OGL0420P5  E    66 84                    01                                S01117
     O         AND  N79                                                         LUC108
     O                       FICHE               16                             S01146
     O********E** 02   66                                          S01146 S01117
     O          E    66 84                    02                                S01117
     O         AND  N79                                                                    LUC108
1906 O*****                              31 '-   -    -'                  S01117
1907 O*****                    CNUM      21                               S01117
1908 O*****                    CCY       25                               S01117
1909 O*****                    ACOD      30                               S01117
1910 O*****                    ACSQ      33                               S01117
1911 O*****           N27      ACNO      45                               S01117
     O               58      BRCA                18                             S01117
     O               58                          19 '-'                         S01117
     O**********                         35 '-   -    -'                               S01117 CGL029
     O**********                         41 '-   -    -'                               CGL029 245223
     O                                           26 '-'                                       245223
     O                                           30 '-'                                       245223
     O                                           41 '-'                                       245223
     O                       CNUM                25                             S01117
     O                       CCY                 29                             S01117
     O**********               ACOD      34                                            S01117 CGL029
     O**********               ACSQ      37                                            S01117 CGL029
     O**********      N27      ACNO      49                                            S01117 CGL029
     O                       ACOD                40                                           CGL029
     O                       ACSQ                43                                           CGL029
     O              N27      ACNO                55                                           CGL029
1912 O                  35                       74 'DEMAND STATEMENT'
1913 O*       H   04   67                                                 S01091
1913 O********E** 04   67                                       S01091    S01117
1913 O          E    67 84                    04                                S01117
     O         AND  N79                                                                    LUC108
1914 O***********            36CNA1      50                               S01194
1914 O***********            36BCCNA1    50                         S01194BHF093
1914 O                     36@WCNA1              50                             BHF093
1915 O*       H   05   67                                                 S01091
1915 O********E** 05   67                                       S01091    S01117
1915 O          E    67 84                    05                                S01117
     O         AND  N79                                                                    LUC108
1916 O***********            36CNA2      50                               S01194
1916 O***********            36BCCNA2    50                         S01194BHF093
1916 O                     36@WCNA2              50                             BHF093
     O/COPY WNCPYSRC,GL0420O099
1917 O*       H   06   67                                                 S01091
1917 O********E** 06   67                                       S01091    S01117
1917 O          E    67 84                    06                                S01117
     O         AND  N79                                                                    LUC108
1918 O***********            36CNA3      50                               S01194
1918 O***********            36BCCNA3    50                         S01194BHF093
1918 O                     36@WCNA3              50                             BHF093
1919 O*       H   07   67                                                 S01091
1919 O********E** 07   67                                       S01091    S01117
1919 O          E    67 84                    07                                S01117
     O         AND  N79                                                                    LUC108
1920 O***********            36CNA4      50                               S01194
1920 O***********            36BCCNA4    50                         S01194BHF093
1920 O                     36@WCNA4              50                             BHF093
1921 O*       H        66 36                                              S01091
1921 O*       E        66 36                                              S01091
1922 O*      OR   07   66N36                                              S01125
1921 O********E** 07   66 36                                    S01125    S01117
1922 O*******OR**      66N36                                    S01125    S01117
1921 O          E    66 36 84                 07                                S01117
     O         AND  N79                                                         LUC108
1922 O         OR    66N36 84                                                   S01117
     O         AND  N79                                                                    LUC108
1923 O***********                        68 'BRANCH -'                    S01194
1923 O                  58                       68 'BRANCH -'                  S01194
1924 O***********              BRNM      99                               S01194
     O                  58   A8BRNM              99                             S01194
1925 O*       H   08   66                                                 S01091
1925 O********E** 08   66                                       S01091    S01117
1925 O******    E    66 84                    08                                S01117       240776A
1926 O***********              PAGE  3   99                               S01117
1926 O******                 PAGE5         3     99                             S01117       240776A
1927 O*       H   10   66                                                 S01091
1927 O********E** 10   66                                       S01091    S01117
1927 O          E    66 84                    10                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GLH00372
1928 O                       ANAM                43
     O/COPY WNCPYSRC,GL0420O135
1929 O                       CCNM                68
1930 O                       RUNA                85
     O/COPY WNCPYSRC,GL0420O065
1931 O                       STPA          3     98
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP9                                           S01408
     O*                                                                   S01408
1932 O*       H   16   66                                                 S01091
1932 O********E** 16   66                                       S01091    S01117
1932 O          E    66 84                    16                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O124
1933 O                                           55 'B/F'
1934 O                       LSTDA               23
     O/COPY WNCPYSRC,GL0420O167
1935 O                     70PSTBF              100 '   ,   ,   ,   , 0 CR'
1936 O                     71PSTBF              100 '  ,   ,   ,   , 0 . CR'
1937 O                     72PSTBF              100 ' ,   ,   ,   , 0 .  CR'
1938 O                     73PSTBF              100 '   ,   ,   , 0 .   CR'
1939 O               83                         100 'DR'
     O/COPY WNCPYSRC,GL0420O086
     O*                                                                   CEU013
     O          E    66 84 10                 17                                CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           78 '('                         CEU013
     O                     KAEUPBF              101 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              101 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              101 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              101 '   ,   ,   , 0 .   CR)'    CEU013
     O               83                         101 'DR)'                       CEU013
     O*                                                                   CEU013
1940 O*
1941 O***     D 1      44 51 04                                           S01091
     O/COPY WNCPYSRC,GL0420O136
1941 O          E    44 51 04DET         1                                      S01091
     O*******AND*     N12                                       S01110    S01117
     O         AND  N12 84                                                      S01117
     O         AND  N79                                                                    LUC108
1942 O                       PSTDA               23
1943 O                                           27 'DR'
1944 O                     22                    27 'CR'
1945 O                                           42 'RATE CHANGE TO'
1946 O                       INTR                56 '  0 .       -'
1947 O                                           57 '%'
     O/COPY WNCPYSRC,GL0420O087
1948 O***     D 1      44 51N04                                           S01091
1948 O          E    44 51N04DET         1                                      S01091
1960 O         AND   84                                                         S01117
     O         AND  N79                                                                    LUC108
1949 O                       PSTDA               23
1950 O                       PNAR                55
     O/COPY WNCPYSRC,GL0420O149
1951 O                     70PSTA                74 ' ,   ,   ,   , 0 '
1952 O                     71PSTA                74 '   ,   ,   , 0 . '
1953 O                     72PSTA                74 '  ,   ,   , 0 .  '
1954 O                     73PSTA                74 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O150
1955 O                                           76 'DR'
1956 O                     22                    76 'CR'
     O/COPY WNCPYSRC,GL0420O088
     O*                                                                   CEU013
     O          E    44 51N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       ROCCY               28                             CEU013
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               49 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    44 51N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O         AND  N79                                                                    LUC108
     O                       W#ORIG              65                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP16                                           S01408
     O*                                                                   S01408
1957 O**   END OF POSTING DATE ONLY
1958 O**
1959 O*       T 00     L1 44 49                                           S01091
1959 O          E    L1 44 49BAL         0  0                                   S01091
1960 O*******AND*     N52                                                 S01117
1960 O         AND  N52 84                                                      S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O168
1961 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1962 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1963 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1964 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O169
1965 O                     47                   100 'DR'
1966 O**   END OF PAGE IND 45
1967 O**
1968 O********E*1         44 45ENDPG                            S01091    S01117
1968 O          E    84 44 45ENDPG       1                                      S01117
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
1968 O*       T 1         44 45                                           S01091
1969 O*      OR           44 52
1970 O                                           55 'C/F'
     O/COPY WNCPYSRC,GL0420O170
1971 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'
1972 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'
1973 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'
1974 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O171
1975 O                     47                   100 'DR'
     O*                                                                   CEU013
     O          E    84 44 45ENDPG       1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           78 '('                         CEU013
     O                     KAEUPBAL             101 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             101 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             101 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             101 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   101 'DR)'                       CEU013
     O*                                                                   CEU013
1969 O*       T 1         44 52                                      S1091S01091
1969 O********E*1         44 52TOT                              S01091    S01117
1969 O          E    84 44 52TOT         1                                      S01117
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
1970 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O172
1971 O                     70PSTBAL             100 '   ,   ,   ,   , 0 CR'     S01091
1972 O                     71PSTBAL             100 '  ,   ,   ,   , 0 . CR'    S01091
1973 O                     72PSTBAL             100 ' ,   ,   ,   , 0 .  CR'    S01091
1974 O                     73PSTBAL             100 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O173
1975 O                     47                   100 'DR'                        S01091
     O*                                                                   CEU013
     O          E    84 44 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           78 '('                         CEU013
     O                     KAEUPBAL             101 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             101 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             101 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             101 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   101 'DR)'                       CEU013
     O*                                                                   216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             216006
     O          E    84 44 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O104
     O*                                                                   CEU013
1976 O**   END OF PAGE ONLY
1977 O**
1978 O*       T 1         44 45                                           S01091
1978 O********E*1         44 45ENDPG                            S01091    S01117
1978 O          E    84 44 45ENDPG       1                                      S01117
     O         AND  N79                                                                    LUC108
1979 O                                           85 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP22                                           S01408
     O*                                                                   S01408
     O********E*2 03           ERPT5                                                   S01117 239641
     O          E            ERPT5       2                                                    239641
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
1980 O/EJECT
1981 O*****MPRINTS5BEGINS****H*E*R*E***                                   S01125
      *                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP25                                           S01408
      *                                                                   S01408
1981 O*    GL0420P6BEGINS    H E R E                                      S01125
1982 O*                      -------
1983 O*
1984 O*PRINTS5H   03   80                                                 S01091
1984 O*PRINTS5E   03   80                                                 S01125
1624 O*L0420P6E   03   80                                                 S01146
1624 O*L0420P6E** 01   80                                          S01146 S01117
1984 OGL0420P6  E    80 84                    01                                S01117
     O         AND  N79                                                         LUC108     O
     O                       FICHE               16                             S01146
     O********E** 03   80                                          S01146 S01117
     O          E    80 84                    03                                S01117
     O         AND  N79                                                                    LUC108
1985 O*               N14      CNA1      35
1985 O***********              CNA1      35                               S01194
1985 O***********              BCCNA1    35                         S01194BHF093
1985 O                       @WCNA1              35                             BHF093
1986 O                                           76 '*MANAGEMENT STATEMENT*'
1987 O*       H   04   81                                                 S01091
1987 O********E** 04   81                                       S01091    S01117
1987 O          E    81 84                    04                                S01117
     O         AND  N79                                                                    LUC108
1988 O*               N14      CNA2      35
1988 O***********              CNA2      35                               S01194
1988 O***********              BCCNA2    35                         S01194BHF093
1988 O                       @WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O100
1989 O*       H   05   81                                                 S01091
1989 O********E** 05   81                                       S01091    S01117
1989 O          E    81 84                    05                                S01117
     O         AND  N79                                                                    LUC108
1990 O*               N14      CNA3      35
1990 O***********              CNA3      35                               S01194
1990 O***********              BCCNA3    35                         S01194BHF093
1990 O                       @WCNA3              35                             BHF093
1991 O*       H   06   81                                                 S01091
1991 O********E** 06   81                                       S01091    S01117
1991 O          E    81 84                    06                                S01117
     O         AND  N79                                                                    LUC108
1992 O*               N14      CNA4      35
1992 O***********              CNA4      35                               S01194
1992 O***********              BCCNA4    35                         S01194BHF093
1992 O                       @WCNA4              35                             BHF093
     O/COPY WNCPYSRC,GL0420O072
1993 O*
1994 O*
1995 O*       H   07   80N14                                              S01091
1995 O********E** 07   80                                       S01091    S01117
1995 O          E    80 84                    07                                S01117
     O         AND  N79                                                                    LUC108
     O
1996 O* ETC.
1997 O*****                              49 'OUR REF'                     S01117
     O                                           45 'OUR REF'                   S01117
     O/COPY WNCPYSRC,GL0420O073
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
1998 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
1999 O                       CNUM                57
2000 O                       CCY                 61
     O**********               ACOD      66                                                   CGL029
     O**********               ACSQ      69                                                   CGL029
     O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
2004 O*************                      97 'BRANCH -'                    S01194
2004 O                  58                       97 'BRANCH -'                  S01194
2005 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
2006 O*       H   08   80N14                                              S01091
2006 O********E** 08   80                                       S01091    S01117
2006 O******    E    80 84                    08                                S01117       240776A
2007 O***********              PAGE  3  128                               S01117
     O/COPY WNCPYSRC,GL0420O074
2007 O******                 PAGE6         3    128                             S01117       240776A
2008 O*       H   10   80N14                                              S01091
2008 O********E** 10   80                                       S01091    S01117
2008 O          E    80 84                    10                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GLH00373
2009 O                                           10 'ACCOUNT'
2010 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00374
2011 O                                           48 'CURRENCY'
2012 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O137
2013 O                                           77 'DATE'
2014 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O138
2015 O                                          102 'PAGE'
     O/COPY WNCPYSRC,GL0420O066
2016 O                       STPA          3    108
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OO10                                           S01408
     O*                                                                   S01408
2017 O*       H   13   80N14                                              S01091
2017 O********E** 13   80                                       S01091    S01117
2017 O          E    80 84                    13                                S01117
     O         AND  N79                                                                    LUC108
2018 O                                            7 'POSTING'
2019 O                                           16 'VALUE'
2020 O                                           27 'CHEQUE'
2021 O                                           50 'NARRATIVE'
     O/COPY WNCPYSRC,GL0420O109
2022 O                                           76 'DEBITS'
2023 O                                           99 'CREDITS'
2024 O                                          121 'BALANCE'
2025 O*       H   14   80N14                                              S01091
2025 O********E** 14   80                                       S01091    S01117
2025 O          E    80 84                    14                                S01117
     O         AND  N79                                                                    LUC108
2026 O                                            6 'DATE'
2027 O                                           16 'DATE'
2028 O                                           25 'NO'
     O/COPY WNCPYSRC,GL0420O125
2029 O*       H   16   80N14                                              S01091
2029 O********E** 16   80                                       S01091    S01117
2029 O          E    80 84                    16                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O126
2030 O                                           60 'B/F'
2031 O                       LSTDA                8
     O/COPY WNCPYSRC,GL0420O174
2032 O                     70PSTBF              127 '   ,   ,   ,   , 0 CR'
2033 O                     71PSTBF              127 '  ,   ,   ,   , 0 . CR'
2034 O                     72PSTBF              127 ' ,   ,   ,   , 0 .  CR'
2035 O                     73PSTBF              127 '   ,   ,   , 0 .   CR'
2036 O                  83                      127 'DR'
     O/COPY WNCPYSRC,GL0420O089
     O*                                                                   CEU013
     O          E    80 84 10                 17                                CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBF              128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              128 '   ,   ,   , 0 .   CR)'    CEU013
     O                  83                      128 'DR)'                       CEU013
     O*                                                                   CEU013
2037 O***     D 1      41 51 34                                           S01091
     O/COPY WNCPYSRC,GL0420O139
2037 O          E    41 51 34DET         1                                      S01091
2038 O***    AND       04                                                 S01110
     O*******AND*     N12 04                                      S01110  S01117
     O         AND  N12 04 84                                                   S01117
     O         AND  N79                                                                    LUC108
2039 O                       PSTDA                8
2040 O                     69VALDA               18
2041 O                                           32 'DR'
2042 O                     22                    32 'CR'
2043 O                                           47 'RATE CHANGE TO'
2044 O                       INTR                61 '  0 .       -'
2045 O                                           62 '%'
     O/COPY WNCPYSRC,GL0420O090
2046 O***     D 1      41 51 34                                           S01091
2046 O          E    41 51 34DET         1                                      S01091
2047 O*******AND*     N04                                                 S01117
2047 O         AND  N04 84                                                      S01117
     O         AND  N79                                                                    LUC108
2048 O                       PSTDA                8
2049 O                     69VALDA               18
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP4                                           S01408
     O*                                                                   S01408
2050 O              N25      CHQN                28
2051 O                       PNAR                60
     O/COPY WNCPYSRC,GL0420O151
2052 O                  23 70PSTA                81 ' ,   ,   ,   , 0 '
2053 O                  23 71PSTA                81 '   ,   ,   , 0 . '
2054 O                  23 72PSTA                81 '  ,   ,   , 0 .  '
2055 O                  23 73PSTA                81 ' ,   ,   , 0 .   '
2056 O                  22 70PSTA               103 ' ,   ,   ,   , 0 '
2057 O                  22 71PSTA               103 '   ,   ,   , 0 . '
2058 O                  22 72PSTA               103 '  ,   ,   , 0 .  '
2059 O                  22 73PSTA               103 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O091
     O*                                                                   CEU013
     O          E    41 51 34DET         1                                      CEU013
     O         AND  N04 84 78                                                   CEU013
     O         AND  N79                                                                    LUC108
     O                       ROCCY               33                             CEU013
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               54 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    41 51 34DET         1                                      216937
     O         AND  N04 84 53                                                   216937
     O         AND  N79                                                                    LUC108
     O                       W#ORIG              70                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP17                                           S01408
     O*                                                                   S01408
2060 O**   END OF POSTING DATE ONLY
2061 O**
2062 O*       T 00     L1 41 49                                           S01091
2062 O          E    L1 41 49BAL         0  0                                   S01091
2063 O*******AND*     N52 34                                              S01117
2063 O         AND  N52 34 84                                                   S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O175
2064 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
2065 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
2066 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
2067 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O176
2068 O                     47                   127 'DR'
2072 O**   END OF PAGE IND 45
2073 O**
2074 O*       T 1         41 45                                           S01091
2074 O          E       41 45ENDPG       1                                      S01091
2075 O*******AND*      34                                                 S01117
2075 O         AND   34 84                                                      S01117
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
2076 O*      OR           41 52
2077 O*      AND       34
2078 O                                           60 'C/F'
     O/COPY WNCPYSRC,GL0420O177
2079 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'
2080 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'
2081 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'
2082 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O178
2083 O                     47                   127 'DR'
     O*                                                                   CEU013
     O          E       41 45ENDPG       1                                      CEU013
     O         AND   34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
2083 O*                                                                   CEU013
2076 O*       T 1         41 52                                      S1091S01091
2076 O          E       41 52TOT         1                                      S01091
2077 O*******AND*      34                                       S01091    S01117
2077 O         AND   34 84                                                      S01117
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
2078 O                                           60 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O179
2079 O                     70PSTBAL             127 '   ,   ,   ,   , 0 CR'     S01091
2080 O                     71PSTBAL             127 '  ,   ,   ,   , 0 . CR'    S01091
2081 O                     72PSTBAL             127 ' ,   ,   ,   , 0 .  CR'    S01091
2082 O                     73PSTBAL             127 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O180
2083 O                     47                   127 'DR'                        S01091
     O*                                                                   CEU013
     O          E       41 52TOT         1                                      CEU013
     O         AND   34 84                                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              65                             156327
     O                                          105 '('                         CEU013
     O                     KAEUPBAL             128 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             128 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             128 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             128 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   128 'DR)'                       CEU013
     O*                                                                   216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             216006
     O          E       41 52TOT         1                                      216006
     O         AND   34 84                                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O105
     O*                                                                   CEU013
2084 O**   END OF PAGE ONLY
2085 O**
2086 O*       T 1         41 45                                           S01091
2086 O          E       41 45ENDPG       1                                      S01091
2087 O*******AND*      34                                                 S01117
2087 O         AND   34 84                                                      S01117
     O         AND  N79                                                                    LUC108
2088 O                                          116 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP23                                           S01408
     O*                                                                   S01408
     O********E*1 03           ERPT6                                                   S01117 239641
     O          E            ERPT6       1                                                    239641
     O         AND  N33                                                         S01377
     O         AND  N79                                                                    LUC108
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
     O/COPY WNCPYSRC,GL0420O122
2310 O********T**202   LR                                       E10433    S01117
     OGL0420AU  T    LR                     2 02                                S01117
     O         AND  N79                                                                    LUC108
     O***********                        22 'REFERENCE GL0420'            S01117
     O                                           24 'REFERENCE GL0420AU'        S01117
2312 O*                        TITL      92                     E10433    S01161
2312 O********                 TITL      92                     E16681    S01194
     O                       BJURPT              92                             S01194
2313 O                                          104 'DATE'                      E10433
2314 O                       RUNA               113                             E10433
0523 O                                          122 'PAGE'                      S01117
0524 O                       PAGE1              127                             S01117
     O/COPY WNCPYSRC,GL0420O092
2315 O*                                                                   E10433
2316 O          T    LR                     1                                   E10433
     O         AND  N79                                                                    LUC108
2317 O                                           70 'BALANCE STATEMENTS'        E10433
     O                                           85 'RUN CONTROLS'              S01117
2318 O          T    LR                     1                                   E10433
     O         AND  N79                                                                    LUC108
2319 O                                           70 '------------------'        E10433
2320 O          T    LR                       15                                E10433
     O         AND  N79                                                                    LUC108
2321 O                                           30 'FILE CONTROLS'             E10433
2322 O***********                        58 'INPUT'                                    E10433 CGL061
2323 O                                           81 'CALCULATED'                E10433
2324 O********T** 17   LR                                       E10433    S01161
2325 O***********                        29 'NO. POSTING '      E10433    S01161
     O***********                        38 'RECORDS :'         E10433    S01161
2326 O***********              POSSIZ3   58                     E10433    S01161
2327 O***********              SUM   3   84                     E10433    S01161
2328 O***********            84         111 '*** OUT OF BALANCE E10433    S01161
2324 O********T** 19   LR                                       E10433    S01161
2325 O***********                        29 'NO. POSTINGS'      E10433    S01161
     O***********                        39 'DELETED :'         E10433    S01161
2326 O***********              NODEL 3   58                     E10433    S01161
2324 O********T** 21   LRN84                                    E10433    S01161
2325 O***********                        29 'NO. POSTINGS'      E10433    S01161
     O***********                        41 'REMAINING :'       E10433    S01161
2326 O***********              POSSO 3   58                     E10433    S01161
2338 O********T** 24   LR                                       E10433    S01161
2338 O          T    LRNU7                    17                                S01161
     O         AND  N79                                                                    LUC108
2339 O                                           31 'NO. STATEMENTS'            E10433
     O                                           45 'RECORDS READ:'             E10433
2340 O***********              STMSIZ3   58                                            E10433 CGL061
2341 O                       TNAR          3     84                             E10433
2342 O******************  86            111 '*** OUT OF BALANCE ***'                   E10433 CGL061
     O          T    U7 U8 LR            3                                      E10433
     O         AND  N79                                                                    LUC108
     O                                           42 '***REFERENCE'              E10433
     O***********              DBPGM     51                     E10433    S01194
     O                       DBPGM               53                             S01194
     O                                           71 'DATABASE ERROR AT'         E10433
     O***********              DBASE     74                     E10433    S01194
     O                       DBASE               75                             S01194
     O          T    U7 U8 LR            2  2                                   E10433
     O         AND  N79                                                                    LUC108
     O                                           37 'FILE NAME'                 E10433
     O***********              DBFILE    43                     E10433    S01194
     O***********                        48 'KEY'               E10433    S01194
     O***********              DBKEY     78                     E10433    S01194
     O                       DBFILE              46                             S01194
     O                                           51 'KEY'                       S01194
     O                       DBKEY               81                             S01194
2343 O********T*3      LR                                       E10433    S01161
2344 O***********                        76 '*** END OF REPORT *E10433    S01161
2089 O*
2090 O**************
2091 O/EJECT
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OO14                                           S01408
     O*                                                                   S01408
2092 O*PRINT  H   03   87                                                 S01091
2092 O*PRINT  E   03   87                                                 S01125
1624 O*L0420P1E   03   87                                                 S01146
1624 O*L0420P1E** 01   87                                          S01146 S01117
1624 OGL0420P1  E    87 84                    01                                S01117
     O         AND  N79                                                         LUC108
     O                       FICHE               16                             S01146
     O********E** 03   87                                          S01146 S01117
     O          E    87 84                    03                                S01117
     O         AND  N79                                                                    LUC108
2093 O***********         36   CNA1      35                               S01194
2093 O***********         36   BCCNA1    35                         S01194BHF093
2093 O                  36   @WCNA1              35                             BHF093
2094 O                  35                       71 'DEMAND STATEMENT'
2095 O*       H   04   89                                                 S01091
2095 O********E*  04   89                                       S01091    S01117
2095 O          E    89 84                    04                                S01117
     O         AND  N79                                                                    LUC108
2096 O***********            36CNA2      35                               S01194
2096 O***********            36BCCNA2    35                         S01194BHF093
2096 O                     36@WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O101
2097 O*       H   05   89                                                 S01091
2097 O********E*  05   89                                       S01091    S01117
2097 O          E    89 84                    05                                S01117
     O         AND  N79                                                                    LUC108
2098 O***********            36CNA3      35                               S01194
2098 O***********            36BCCNA3    35                         S01194BHF093
2098 O                     36@WCNA3              35                             BHF093
2099 O*       H   06   89                                                 S01091
2099 O********E*  06   89                                       S01091    S01117
2099 O          E    89 84                    06                                S01117
     O         AND  N79                                                                    LUC108
2100 O***********            36CNA4      35                               S01194
     O***********            36BCCNA4    35                         S01194BHF093
     O                     36@WCNA4              35                             BHF093
2101 O*
2102 O*
2103 O*       H   07   87                                                 S01091
2103 O********E*  07   87                                       S01091    S01117
2103 O          E    87 84                    07                                S01117
     O         AND  N79                                                                    LUC108
2104 O* ETC.
2105 O*****                              49 'OUR REF'                     S01117
     O/COPY WNCPYSRC,GL0420O110
     O                                           45 'OUR REF'                   S01117
     O/COPY WNCPYSRC,GL0420O111
     O               58      BRCA                50                             S01117
     O               58                          51 '-'                         S01117
2106 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
2107 O                       CNUM                57
2108 O                       CCY                 61
2109 O**********               ACOD      66                                                   CGL029
2110 O**********               ACSQ      69                                                   CGL029
2111 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
2112 O*************                      97 'BRANCH -'                    S01194
     O/COPY WNCPYSRC,GL0420O112
2112 O                  58                       97 'BRANCH -'                  S01194
2113 O***********              BRNM     128                               S01194
     O                  58   A8BRNM             128                             S01194
2114 O*       H   08   87                                                 S01091
2114 O********E*  08   87                                       S01091    S01117
2114 O******    E    87 84                    08                                S01117       240776A
2115 O******                 PAGE          3    128                                          240776A
     O/COPY WNCPYSRC,GL0420O113
2116 O*       H   10   87                                                 S01091
2116 O********E** 10   87                                       S01091    S01117
2116 O          E    87 84                    10                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O114
2117 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00375
2118 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O140
2119 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O067
2120 O                       STPA          3    107
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OO11                                           S01408
     O*                                                                   S01408
2121 O*       H   16   87                                                 S01091
2121 O********E*  16   87                                       S01091    S01117
2121 O          E    87 84                    16                                S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O127
2122 O**
2123 O**   NARRATIVES OVERLAP WITH THE DEBITS BY ONE COLUMN.
2124 O**
2125 O                       LSTDA                7
2126 O                                           55 'B/F'
     O/COPY WNCPYSRC,GL0420O181
2127 O                     70PSTBF              110 '   ,   ,   ,   , 0 CR'
2128 O                     71PSTBF              110 '  ,   ,   ,   , 0 . CR'
2129 O                     72PSTBF              110 ' ,   ,   ,   , 0 .  CR'
2130 O                     73PSTBF              110 '   ,   ,   , 0 .   CR'
2131 O                     47                   110 'DR'
     O*TO ENSURE ACCURATE CLEARED BALANCE BFWD IS SHOWN ON FIRST &
     O*  SUBSEQUENT PAGES OF STATMENTS
2132 O                     70CFBF               132 '   ,   ,   ,   , 0 CR'
2133 O                     71CFBF               132 '  ,   ,   ,   , 0 . CR'
2134 O                     72CFBF               132 ' ,   ,   ,   , 0 .  CR'
2135 O                     73CFBF               132 '   ,   ,   , 0 .   CR'
2136 O                     28                   132 'DR'
     O/COPY WNCPYSRC,GL0420O093
     O*                                                                   CEU013
     O          E    87 84 10                 17                                CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBF              111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O*                                                                   CEU013
2137 O***     D 1      40 75 51                                           S01091
2137 O********E*1******40*75*51**********                          S01091 059213
     O/COPY WNCPYSRC,GL0420O141
2137 O          E    40 75 51DET         1                                      059213
     O         AND   84                                                         S01117
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O182
2138 O                     70VDDR                71 ' ,   ,   ,   , 0 '
2139 O                     71VDDR                71 '   ,   ,   , 0 . '
2140 O                     72VDDR                71 '  ,   ,   , 0 .  '
2141 O                     73VDDR                71 ' ,   ,   , 0 .   '
2142 O                                           40 '**AMOUNT CLEARED SINCE L'
2143 O                                           55 'AST STATEMENT**'
2144 O                     70VDCR                88 ' ,   ,   ,   , 0 '
2145 O                     71VDCR                88 '   ,   ,   , 0 . '
2146 O                     72VDCR                88 '  ,   ,   , 0 .  '
2147 O                     73VDCR                88 ' ,   ,   , 0 .   '
2148 O                     70VDCBBF             132 '   ,   ,   ,   , 0 CR'
2149 O                     71VDCBBF             132 '  ,   ,   ,   , 0 . CR'
2150 O                     72VDCBBF             132 ' ,   ,   ,   , 0 .  CR'
2151 O                     73VDCBBF             132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O183
2152 O                     32                   132 'DR'
2153 O***     D 1      40 51 04                                           S01091
2153 O          E    40 51 04DET         1                                      S01091
     O*******AND*     N12                                       S01110    S01117
     O         AND  N12 84                                                      S01117
     O         AND  N79                                                                    LUC108
2154 O                       PSTDA                7
2155 O                     69VALDA               15
2156 O                                           27 'DR'
2157 O                     22                    27 'CR'
2158 O                                           42 'RATE CHANGE TO'
2159 O                       INTR                56 '  0 .       -'
2160 O                                           57 '%'
     O/COPY WNCPYSRC,GL0420O094
2161 O***     D 1      40 51N04                                           S01091
2161 O          E    40 51N04DET         1                                      S01091
     O         AND   84                                                         S01117
     O         AND  N79                                                                    LUC108
2162 O                       PSTDA                7
2163 O                     69VALDA               15
     O*                                                                   S01408
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OOP5                                           S01408
     O*                                                                   S01408
2164 O              N25      CHQN                24
     O/COPY WNCPYSRC,GL0420O152
2165 O                  23 70PSTA                71 ' ,   ,   ,   , 0 '
2166 O                  23 71PSTA                71 '   ,   ,   , 0 . '
2167 O                  23 72PSTA                71 '  ,   ,   , 0 .  '
2168 O                  23 73PSTA                71 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O153
2169 O                       PNAR                55
     O/COPY WNCPYSRC,GL0420O154
2170 O                  22 70PSTA                88 ' ,   ,   ,   , 0 '
2171 O                  22 71PSTA                88 '   ,   ,   , 0 . '
2172 O                  22 72PSTA                88 '  ,   ,   , 0 .  '
2173 O                  22 73PSTA                88 ' ,   ,   , 0 .   '
     O/COPY WNCPYSRC,GL0420O095
     O          E    40 51N04DET         1                                      CEU013
     O         AND   84 78                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       ROCCY               28                             CEU013
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '       CEU013
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '      CEU013
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '      CEU013
     O                     KHROAMT               49 '   ,   ,   , 0 .   '       CEU013
     O*                                                                   216937
     O          E    40 51N04DET         1                                      216937
     O         AND   84 53                                                      216937
     O         AND  N79                                                                    LUC108
     O                       W#ORIG              65                             216937
     O*                                                                   216937
     O** Core hook for externalisation.                                   S01408
     O/COPY WNCPYSRC,GL0420OP18                                           S01408
     O*                                                                   S01408
2174 O**   END OF POSTING DATE ONLY
2175 O**
2176 O*       T 00     L1 40 49                                           S01091
2176 O          E    L1 40 49BAL         0  0                                   S01091
     O*******AND*     N52 51                                              S01117
     O         AND  N52 51 84                                                   S01117
     O         AND  N79                                                                    LUC108
2178 O*      OR           40 19                                           S01091
2179 O*      AND      N18 52                                              S01091
     O/COPY WNCPYSRC,GL0420O184
2180 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'
2181 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'
2182 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'
2183 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'
2184 O                     47                   110 'DR'
2185 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'
2186 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2187 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2188 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O185
2189 O                     37                   132 'DR'
2178 O**      T 00        40 19                                      S1091S01091
2178 O********E*00********40*19TOT*******                          S01091 059213
2179 O*******AND*     N18 52                                    S01091    S01117
2179 O*******AND******N18*52*84**********                          S01117 059213
2180 O***********************70PSTBAL***110 '   ,   ,   ,   , 0 CR'S01091 059213
2181 O**********************71PSTBAL***110 '  ,   ,   ,   , 0 . CR'S01091 059213
2182 O**********************72PSTBAL***110 ' ,   ,   ,   , 0 .  CR'S01091 059213
2183 O***********************73PSTBAL***110 '   ,   ,   , 0 .   CR'S01091 059213
2184 O***********************47*********110 'DR'                   S01091 059213
2185 O***********************70CLBAL****132 '   ,   ,   ,   , 0 CR'S01091 059213
2186 O**********************71CLBAL****132 '  ,   ,   ,   , 0 . CR'S01091 059213
2187 O**********************72CLBAL****132 ' ,   ,   ,   , 0 .  CR'S01091 059213
2188 O***********************73CLBAL****132 '   ,   ,   , 0 .   CR'S01091 059213
2189 O***********************37*********132 'DR'                   S01091 059213
2190 O**   C/F BALANCE PRINTED WHEN ITEMS CLEARING AFTER LAST POST
2191 O**
2192 O*       T 1         40 18                                           S01091
2192 O********E*1         40 18TOT                              S01091    S01117
2192 O          E    84 40 18TOT         1                                      S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2193 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O186
2194 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'
2195 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'
2196 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'
2197 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'
2198 O                     47                   110 'DR'
2199 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'
2200 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2201 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2202 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O187
2203 O                     28                   132 'DR'
     O*                                                                   CEU013
     O          E    84 40 18TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBAL             111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O/COPY WNCPYSRC,GL0420O106
     O*                                                                   CEU013
2204 O**   END OF PAGE WHEN ITEMS TO BE CLEARED AFTER LAST POST
2205 O**
2206 O*       T   50      40 18                                           S01091
2206 O********E*  50      40 18TOT                              S01091    S01117
2206 O          E    84 40 18TOT              50                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2207 O                                          125 '- CONTD'
     O*                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP24                                           S01408
     O*                                                                   S01408
2208 O**   TOTAL TIME HEADINGS OUTPUT ONLY WHEN ITEMS CLEARED AFTER
2209 O**
2210 O*       T   03      40 18                                           S01091
2210 O********E*  03      40 18TOT                              S01091    S01117
2210 O          E    84 40 18TOT              03                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2211 O***********         36   CNA1      35                               S01194
2211 O***********         36   BCCNA1    35                         S01194BHF093
2211 O                  36   @WCNA1              35                             BHF093
2212 O                  35                       71 'DEMAND STATEMENT'
     O                  58                       85 'BRANCH    -'               S01117
     O                  58   BRCA                84                             S01117
     O                  58   A8BRNM             115                             S01117
2213 O*       T   04      40 18                                           S01091
2213 O********E*  04      40 18TOT                              S01091    S01117
2213 O          E    84 40 18TOT              04                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2214 O***********            36CNA2      35                               S01194
2214 O***********            36BCCNA2    35                         S01194BHF093
2214 O                     36@WCNA2              35                             BHF093
     O/COPY WNCPYSRC,GL0420O102
2215 O*       T   05      40 18                                           S01091
2215 O********E*  05      40 18TOT                              S01091    S01117
2215 O          E    84 40 18TOT              05                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2216 O***********            36CNA3      35                               S01194
2216 O***********            36BCCNA3    35                         S01194BHF093
2216 O                     36@WCNA3              35                             BHF093
2217 O*       T   06      40 18                                           S01091
2217 O********E** 06      40 18TOT                              S01091    S01117
2217 O          E    84 40 18TOT              06                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2218 O***********            36CNA4      35                               S01194
2218 O***********            36BCCNA4    35                         S01194BHF093
2218 O                     36@WCNA4              35                             BHF093
2219 O*
2220 O*
2221 O*       T   07      40 18                                           S01091
2221 O********E** 07      40 18TOT                              S01091    S01117
2221 O          E    84 40 18TOT              07                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2222 O* ETC.
2223 O                                           49 'OUR REF'
2224 O**********                         67 '-   -    -'                                      CGL029
     O**********                         73 '-   -    -'                               CGL029 245223
     O                                           58 '-'                                       245223
     O                                           62 '-'                                       245223
     O                                           73 '-'                                       245223
2225 O                       CNUM                57
2226 O                       CCY                 61
2227 O**********               ACOD      66                                                   CGL029
2228 O**********               ACSQ      69                                                   CGL029
2229 O**********      N27      ACNO      80                                                   CGL029
     O                       ACOD                72                                           CGL029
     O                       ACSQ                75                                           CGL029
     O              N27      ACNO                86                                           CGL029
2230 O***********                        97 'BRANCH -'                    S01117
2231 O***********              BRNM     128                               S01117
2221 O          E    84 40 18TOT              08                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
     O               58                          12 'BRANCH'                    S01117
     O               58      BRCA                16                             S01117
     O               58      A8BRNM              48                             S01194
2232 O*       T   10      40 18                                           S01091
2232 O********E** 10      40 18TOT                              S01091    S01117
2232 O          E    84 40 18TOT              10                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O115
2233 O                       ANAM                33
     O/COPY WNCPYSRC,GLH00376
2234 O                       CCNM                65
     O/COPY WNCPYSRC,GL0420O142
2235 O                       RUNA                87
     O/COPY WNCPYSRC,GL0420O068
2236 O                       STPFF         3    107
     O/COPY WNCPYSRC,GL0420O069
2237 O*       T   16      40 18                                           S01091
2237 O********E** 16      40 18TOT                              S01091    S01117
2237 O          E    84 40 18TOT              16                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2238 O                       LSTDA                7
     O/COPY WNCPYSRC,GL0420O143
2239 O                                           55 'B/F'
     O/COPY WNCPYSRC,GL0420O188
2240 O                     70PSTBF              110 '   ,   ,   ,   , 0 CR'
2241 O                     71PSTBF              110 '  ,   ,   ,   , 0 . CR'
2242 O                     72PSTBF              110 ' ,   ,   ,   , 0 .  CR'
2243 O                     73PSTBF              110 '   ,   ,   , 0 .   CR'
2244 O                     47                   110 'DR'
2245 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'
2246 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2247 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2248 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'
2249 O                     37                   132 'DR'
     O/COPY WNCPYSRC,GL0420O096
     O*                                                                   CEU013
     O          E    84 40 18TOT              17                                CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBF              111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBF              111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBF              111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBF              111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O*                                                                   CEU013
2250 O**   ITEMS CLEARED AFTER LAST POST.
2251 O**
2252 O*       T 1         40 19                                           S01091
2252 O********E*1         40 19TOT                              S01091    S01117
2252 O          E    84 40 19TOT         1                                      S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O189
2253 O                     70VDDR                71 ' ,   ,   ,   , 0 '
2254 O                     71VDDR                71 '   ,   ,   , 0 . '
2255 O                     72VDDR                71 '  ,   ,   , 0 .  '
2256 O                     73VDDR                71 ' ,   ,   , 0 .   '
2257 O                                           40 '** AMOUNT CLEARED AFTER '
2258 O                                           55 'LAST POSTING **'
2259 O                     70VDCR                88 ' ,   ,   ,   , 0 '
2260 O                     71VDCR                88 '   ,   ,   , 0 . '
2261 O                     72VDCR                88 '  ,   ,   , 0 .  '
2262 O                     73VDCR                88 ' ,   ,   , 0 .   '
     O*TO ENSURE ACCURATE CLEARED BALANCE CFWD IS SHOWN ON FIRST &
     O* SUBSEQUENT PAGES OF STATMENTS
2263 O                  52 70CLBF               132 '   ,   ,   ,   , 0 CR'
2264 O                  52 71CLBF               132 '  ,   ,   ,   , 0 . CR'
2265 O                  52 72CLBF               132 ' ,   ,   ,   , 0 .  CR'
2266 O                  52 73CLBF               132 '   ,   ,   , 0 .   CR'
2263 O                  45 70CLBAL              132 '   ,   ,   ,   , 0 CR'
2264 O                  45 71CLBAL              132 '  ,   ,   ,   , 0 . CR'
2265 O                  45 72CLBAL              132 ' ,   ,   ,   , 0 .  CR'
2266 O                  45 73CLBAL              132 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O190
2267 O                     28                   132 'DR'
2268 O**   END OF PAGE IND 45
2269 O**
2270 O*       T 1         40 45                                           S01091
2270 O********E*1         40 45ENDPG                            S01091    S01117
2270 O          E    84 40 45ENDPG       1                                      S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2272 O                                           55 'C/F'
     O/COPY WNCPYSRC,GL0420O191
2273 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'
2274 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'
2275 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'
2276 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'
2277 O                     47                   110 'DR'
2278 O***********************70CLBF*****132 '   ,   ,   ,   , 0 CR'       059213
2279 O***********************71CLBF*****132 '  ,   ,   ,   , 0 . CR'      059213
2280 O***********************72CLBF*****132 ' ,   ,   ,   , 0 .  CR'      059213
2281 O***********************73CLBF*****132 '   ,   ,   , 0 .   CR'       059213
2278 O                     70CLBAL              132 '   ,   ,   ,   , 0 CR'     059213
2279 O                     71CLBAL              132 '  ,   ,   ,   , 0 . CR'    059213
2280 O                     72CLBAL              132 ' ,   ,   ,   , 0 .  CR'    059213
2281 O                     73CLBAL              132 '   ,   ,   , 0 .   CR'     059213
     O/COPY WNCPYSRC,GL0420O192
2282 O                     28                   132 'DR'
     O**                                                                  CEU013
     O          E    84 40 45ENDPG       1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBAL             111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O**                                                                  CEU013
2271 O**      T 1         40 52                                      S1091S01091
2271 O********E*1         40 52TOT                              S01091    S01117
2271 O          E    84 40 52TOT         1                                      S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2272 O                                           55 'C/F'                       S01091
     O/COPY WNCPYSRC,GL0420O193
2273 O                     70PSTBAL             110 '   ,   ,   ,   , 0 CR'     S01091
2274 O                     71PSTBAL             110 '  ,   ,   ,   , 0 . CR'    S01091
2275 O                     72PSTBAL             110 ' ,   ,   ,   , 0 .  CR'    S01091
2276 O                     73PSTBAL             110 '   ,   ,   , 0 .   CR'     S01091
2277 O                     47                   110 'DR'                        S01091
2278 O                     70CLBF               132 '   ,   ,   ,   , 0 CR'     S01091
2279 O                     71CLBF               132 '  ,   ,   ,   , 0 . CR'    S01091
2280 O                     72CLBF               132 ' ,   ,   ,   , 0 .  CR'    S01091
2281 O                     73CLBF               132 '   ,   ,   , 0 .   CR'     S01091
     O/COPY WNCPYSRC,GL0420O194
2282 O                     28                   132 'DR'                        S01091
     O*                                                                   CEU013
     O          E    84 40 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           88 '('                         CEU013
     O                     KAEUPBAL             111 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             111 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             111 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             111 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   111 'DR)'                       CEU013
     O*                                                                   CEU013
2283 O**   SUMMARY OF THIS STATEMENT AT BOTTOM OF LAST PAGE.
2284 O**
2285 O*       T   50      40 52                                           S01091
2285 O********E** 50      40 52TOT                              S01091    S01117
     O/COPY WNCPYSRC,GL0420O116
2285 O          E    84 40 52TOT              50                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
     O/COPY WNCPYSRC,GL0420O195
2286 O                     70CFSB                26 '   ,   ,   ,   , 0 CR'
2287 O                     71CFSB                26 '  ,   ,   ,   , 0 . CR'
2288 O                     72CFSB                26 ' ,   ,   ,   , 0 .  CR'
2289 O                     73CFSB                26 '   ,   ,   , 0 .   CR'
2290 O                     17                    26 'DR'
      *                                                                   S01408
     O/COPY WNCPYSRC,GL0420OP26                                           S01408
      *                                                                   S01408
2291 O                       NDR           3     33
     O/COPY WNCPYSRC,GL0420O196
2292 O                     70PSDR                51 ' ,   ,   ,   , 0 '
2293 O                     71PSDR                51 '   ,   ,   , 0 . '
2294 O                     72PSDR                51 '  ,   ,   , 0 .  '
2295 O                     73PSDR                51 ' ,   ,   , 0 .   '
2296 O                       NCR           3     59
2297 O                     70PSCR                78 ' ,   ,   ,   , 0 '
2298 O                     71PSCR                78 '   ,   ,   , 0 . '
2299 O                     72PSCR                78 '  ,   ,   , 0 .  '
2300 O                     73PSCR                78 ' ,   ,   , 0 .   '
2301 O                     70PSTBAL             109 '   ,   ,   ,   , 0 CR'
2302 O                     71PSTBAL             109 '  ,   ,   ,   , 0 . CR'
2303 O                     72PSTBAL             109 ' ,   ,   ,   , 0 .  CR'
2304 O                     73PSTBAL             109 '   ,   ,   , 0 .   CR'
     O/COPY WNCPYSRC,GL0420O197
2305 O                     47                   109 'DR'
     O*                                                                   CEU013
     O          E    84 40 52TOT         1                                      CEU013
     O         AND  N33 10                                                      CEU013
     O         AND  N79                                                                    LUC108
     O                       BKEURO              60                             156327
     O                                           87 '('                         CEU013
     O                     KAEUPBAL             110 '   ,   ,   ,   , 0 CR)'    CEU013
     O                     KBEUPBAL             110 '  ,   ,   ,   , 0 . CR)'   CEU013
     O                     KCEUPBAL             110 ' ,   ,   ,   , 0 .  CR)'   CEU013
     O                     KDEUPBAL             110 '   ,   ,   , 0 .   CR)'    CEU013
     O                     47                   110 'DR)'                       CEU013
     O*                                                                   216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX1              97                             216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX2              97                             216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX3              97                             216006
     O          E    84 40 52TOT         1                                      216006
     O         AND  N33 82                                                      216006
     O         AND  N79                                                                    LUC108
     O                       WCMTX4              97                             216006
     O/COPY WNCPYSRC,GL0420O117
     O*                                                                   CEU013
2306 O********E** 50      40 45ENDPG                            S01091    S01117
2306 O          E    84 40 45ENDPG            50                                S01117
     O         AND  N33                                                         055721
     O         AND  N79                                                                    LUC108
2306 O*       T   50      40 45                                           S01091
2307 O*******AND      N52                                                 E10604
2308 O                                          125 '- CONTD'
2192 O********E*1 03           ERPT1                                                   S01117 239641
     O          E            ERPT1       1    03                                              239641
     O         AND  N79                                                         LUC108
     O                                           66 '*** END OF REPORT '        S01117
     O               58                          77 'FOR BRANCH '               S01117
     O               58      BRCASV              80                             S01117
     O               58                          84 ' ***'                      S01117
     O              N58                          69 '***'                       S01117
2309 O*
2310 O********T  202   LR                                                 E10433
     O********                           22 'REFERENCE GL0420'            E10433
2312 O********                 TITL      92                               E10433
2313 O********                          104 'DATE'                        E10433
2314 O********                 RUNA     113                               E10433
2315 O********                                                            E10433
2316 O********T  1     LR                                                 E10433
2317 O********                           70 'BALANCE STATEMENTS'          E10433
2318 O********T  1     LR                                                 E10433
2319 O********                           70 '------------------'          E10433
2320 O********T   15   LR                                                 E10433
2321 O********                           30 'FILE CONTROLS'               E10433
2322 O********                           58 'INPUT'                       E10433
2323 O********                           81 'CALCULATED'                  E10433
2324 O****    T   17   LR                                                 S01091
2325 O****                               29 'NO. POSTINGS'                S01091
     O****                               43 'RECORDS READ:'               S01091
2326 O****                     POSSI 3   58                               S01091
2327 O****                     TNPR  3   84                               S01091
2328 O****                   84         111 '*** OUT OF BALANCE ***'      S01091
2324 O********T   17   LR                                           S01091E10433
2325 O********                           29 'NO. POSTING '          S01091E10433
     O********                           38 'RECORDS :'             S01091E10433
2326 O********                 POSSIZ3   58                         S01091E10433
2327 O********                 SUM   3   84                         S01091E10433
2328 O********               84         111 '*** OUT OF BALANCE ***'S01091E10433
2324 O********T   19   LR                                           S01091E10433
2325 O********                           29 'NO. POSTINGS'          S01091E10433
     O********                           39 'DELETED :'             S01091E10433
2326 O********                 NODEL 3   58                         S01091E10433
2324 O********T   21   LRN84                                        S01091E10433
2325 O********                           29 'NO. POSTINGS'          S01091E10433
     O********                           41 'REMAINING :'           S01091E10433
2326 O********                 POSSO 3   58                         S01091E10433
2329 O****    T   19   LR                                                 S01091
2330 O****                               34 'VALUE OF POSTINGS'           S01091
2331 O****                     ZZTOTIZ   55                               S01091
2332 O****                     HND4      59                               S01091
2333 O****                               59 ' '                           S01091
2334 O****                     HPTI  Z   81                               S01091
2335 O****                     HPT4      85                               S01091
2336 O****                               85 ' '                           S01091
2337 O****                              111 '*** OUT OF BALANCE ***'      S01091
2338 O****    T   20   LR                                                 S01091
2338 O********T   24   LR                                                 E10433
2339 O********                           31 'NO. STATEMENTS'              E10433
     O********                           45 'RECORDS READ:'               E10433
2340 O********                 STMSIZ3   58                               E10433
2341 O********                 TNAR  3   84                               E10433
2342 O********            86            111 '*** OUT OF BALANCE ***'      E10433
     O********T 3      U7 U8 LR                                           E10433
     O********                           42 '***REFERENCE'                E10433
     O********                 DBPGM     51                               E10433
     O********                           71 'DATABASE ERROR AT'           E10433
     O********                 DBASE     74                               E10433
     O********T 22     U7 U8 LR                                           E10433
     O********                           37 'FILE NAME'                   E10433
     O********                 DBFILE    43                               E10433
     O********                           48 'KEY'                         E10433
     O********                 DBKEY     78                               E10433
2343 O********T 3      LR                                                 E10433
2344 O********                           76 '*** END OF REPORT ***'       E10433
     O*
     O** Core hook for externalisation.                                   S01408
      *
      * LUC108
      *
     OGL0420P2  E       60 84                 16
     O         AND   79                                                         LUC108
     O                  36   @WCNA1              62
     O                  35                       86 'DEMAND STATEMENT'
     O                       ANAM               117
      *
     O          E       61 84                 17
     O         AND   79                                                         LUC108
     O                     36@WCNA2              62
      *
     O          E       61 84                 18
     O         AND   79                                                         LUC108
     O                     36@WCNA3              62
      *
     O          E       61 84                 19
     O         AND   79                                                         LUC108
     O                     36@WCNA4              62
     O                       CCY                 87
     O                     27BRCA                97
     O                     27                    98 '-'
     O                     27CCY                101
     O                     27                   102 '-'
     O                     27CNUM               108
     O                     27                   109 '-'
     O                     27ACOD               119
     O                     27                   120 '-'
     O                     27ACSQ               122
     O                    N27ACNO               110
      *
     O          E       61 84                 23
     O         AND   79                                                         LUC108
     O                       LSTDN              104
     O                                          106 '-'
     O                       RUNA               116
      *
     O          E       61 84                 25
     O         AND   79                                                         LUC108
     O                       STPA          3     85
     O                       STPP          3    110
      *
     O          E       60 84                 30
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O                                           41 'BALANCE B/F'
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O                     83                   119 'DR'
      *
     O          E    60 84 10            1
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O                     83                   120 'DR)'
      *
     O          E    41 51N34DET         1
     O         AND   04N12 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                                           25 'DR'
     O                     22                    25 'CR'
     O                                           40 'RATE CHANGE TO'
     O                       INTR                53 '  0 .       -'
     O                                           54 '%'
      *
     O          E    41 51N34DET         1
     O         AND  N04 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                  69   VALDA               22
     O                       PNAR                55
     O************  N25                          47 ' CK'                       LUC133
     O***********   N25      CHQN                55                             LUC133
     O              N25NKP                       47 ' CK'                       LUC133
     O              N25NKP   CHQN                55                             LUC133
     O               23 70   PSTA                75 ' ,   ,   ,   , 0 '
     O               23 71   PSTA                75 '   ,   ,   , 0 . '
     O               23 72   PSTA                75 '  ,   ,   , 0 .  '
     O               23 73   PSTA                75 ' ,   ,   , 0 .   '
     O               23                          77 'DR'
     O               22 70   PSTA                83 ' ,   ,   ,   , 0 '
     O               22 71   PSTA                83 '   ,   ,   , 0 . '
     O               22 72   PSTA                83 '  ,   ,   , 0 .  '
     O               22 73   PSTA                83 ' ,   ,   , 0 .   '
     O               22                          85 'CR'
      *
     O          E    41 51N34DET         1
     O         AND  N04 84 78
     O         AND   79                                                         LUC108
     O                       ROCCY               33
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '
     O                     KHROAMT               54 '   ,   ,   , 0 .   '
      *
     O          E       41 45ENDPG            54
     O         AND  N34 84
     O         AND  N33
     O         AND   79                                                         LUC108
     O                                           45 'CARRIED FORWARD'
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E       41 45ENDPG       1
     O         AND     N34 84
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E       41 52TOT              54
     O         AND   34N33 84
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70CLBL1              119 '   ,   ,   ,   , 0 CR'
     O                     71CLBL1              119 '  ,   ,   ,   , 0 . CR'
     O                     72CLBL1              119 ' ,   ,   ,   , 0 .  CR'
     O                     73CLBL1              119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E       41 52TOT              55
     O         AND  N34 84
     O         AND  N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E       41 52TOT         1
     O         AND     N34 84
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E       41 45ENDPG            55
     O         AND     N34 84
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E       41 52TOT              58
     O         AND  N34 84
     O         AND  N33
     O         AND   79                                                         LUC108
     O              N16                          29 'CURRENT PRIME RATE AS AT'
     O              N16      RUNA                37
     O              N16                          39 ':'
     O              N16      G@BRTE              53 ' , 0 .       '
     O                     70PSDR               119 ' ,   ,   ,   , 0 '
     O                     71PSDR               119 '   ,   ,   , 0 . '
     O                     72PSDR               119 '  ,   ,   , 0 .  '
     O                     73PSDR               119 ' ,   ,   , 0 .   '
      *
     O          E       41 52TOT              60
     O         AND     N34 84
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSCR               119 ' ,   ,   ,   , 0 '
     O                     71PSCR               119 '   ,   ,   , 0 . '
     O                     72PSCR               119 '  ,   ,   , 0 .  '
     O                     73PSCR               119 ' ,   ,   , 0 .   '
      *
     O          E            ERPT2       1    03
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           66 '*** END OF REPORT '
     O                  58                       77 'FOR BRANCH '
     O                  58   BRCASV              80
     O                  58                       84 ' ***'
     O                 N58                       69 '***'
      *
      *    GL0420P3  BEGINS  H E R E
      *                      -------
     OGL0420P3  E    62 84                    01
     O         AND   79                                                         LUC108
     O                       FICHE               16
      *
     O          E    62 84                    16
     O         AND   79                                                         LUC108
     O                  36   @WCNA1              62
     O                  35                       86 'DEMAND STATEMENT'
     O                       ANAM               117
      *
     O          E    63 84                    17
     O         AND   79                                                         LUC108
     O                     36@WCNA2              62
      *
     O          E    63 84                    18
     O         AND   79                                                         LUC108
     O                     36@WCNA3              62
      *
     O          E    63 84                    19
     O         AND   79                                                         LUC108
     O                     36@WCNA4              62
     O                       CCY                 87
     O                     27BRCA                97
     O                     27                    98 '-'
     O                     27CCY                101
     O                     27                   102 '-'
     O                     27CNUM               108
     O                     27                   109 '-'
     O                     27ACOD               119
     O                     27                   120 '-'
     O                     27ACSQ               122
     O                    N27ACNO               110
      *
     O          E    63 84                    23
     O         AND   79                                                         LUC108
     O                       LSTDN              104
     O                                          106 '-'
     O                       RUNA               116
      *
     O          E    63 84                    25
     O         AND   79                                                         LUC108
     O                       STPA          3     85
     O                       STPP          3    110
      *
     O          E    62 84                    30
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O                                           41 'BALANCE B/F'
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O                  83                      119 'DR'
      *
     O          E    62 84 10            1
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O                  83                      120 'DR)'
      *
     O          E    51 42 04DET         1
     O         AND     N12 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                                           25 'DR'
     O                     22                    25 'CR'
     O                                           40 'RATE CHANGE TO'
     O                       INTR                53 '  0 .       -'
     O                                           54 '%'
      *
     O          E    51 42N04DET         1
     O         AND         84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                       PNAR                55
     O************  N25                          47 ' CK'                       LUC133
     O***********   N25      CHQN                55                             LUC133
     O              N25NKP                       47 ' CK'                       LUC133
     O              N25NKP   CHQN                55                             LUC133
     O                  23 70PSTA                75 ' ,   ,   ,   , 0 '
     O                  23 71PSTA                75 '   ,   ,   , 0 . '
     O                  23 72PSTA                75 '  ,   ,   , 0 .  '
     O                  23 73PSTA                75 ' ,   ,   , 0 .   '
     O                  23                       77 'DR'
     O                  22 70PSTA                83 ' ,   ,   ,   , 0 '
     O                  22 71PSTA                83 '   ,   ,   , 0 . '
     O                  22 72PSTA                83 '  ,   ,   , 0 .  '
     O                  22 73PSTA                83 ' ,   ,   , 0 .   '
     O                  22                       85 'CR'
      *
     O          E    51 42N04DET         1
     O         AND      84 78
     O         AND   79                                                         LUC108
     O                       ROCCY               33
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '
     O                     KHROAMT               54 '   ,   ,   , 0 .   '
      *
     O          E    84 42 45ENDPG            54
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           45 'CARRIED FORWARD'
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 42 45ENDPG       1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 42 52TOT              54
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70CLBL1              119 '   ,   ,   ,   , 0 CR'
     O                     71CLBL1              119 '  ,   ,   ,   , 0 . CR'
     O                     72CLBL1              119 ' ,   ,   ,   , 0 .  CR'
     O                     73CLBL1              119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E    84 42 52TOT              55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 42 52TOT               1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 42 45ENDPG      55
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E    84 42 52TOT        58
     O         AND     N33N16
     O         AND   79                                                         LUC108
     O                                           29 'CURRENT PRIME RATE AS AT'
     O                       RUNA                37
     O                                           39 ':'
     O                       G@BRTE              53 ' , 0 .       '
      *
     O          E            ERPT3       1       03
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           66 '*** END OF REPORT '
     O                  58                       77 'FOR BRANCH '
     O                  58   BRCASV              80
     O                  58                       84 ' ***'
     O                 N58                       69 '***'
      *
      *    GL0420P1  BEGINS  H E R E
      *                      -------
      *
     OGL0420P1  E    87 84                    01
     O         AND   79                                                         LUC108
     O                       FICHE               16
     O          E    87 84                    16
     O         AND   79                                                         LUC108
     O                  36   @WCNA1              62
     O                  35                       86 'DEMAND STATEMENT'
     O                       ANAM               117
      *
     O          E    89 84                    17
     O         AND   79                                                         LUC108
     O                  36   @WCNA2              62
      *
     O          E    89 84                    18
     O         AND   79                                                         LUC108
     O                  36   @WCNA3              62
      *
     O          E    89 84                    19
     O         AND   79                                                         LUC108
     O                  36   @WCNA4              62
     O                       CCY                 87
     O                  27   BRCA                97
     O                  27                       98 '-'
     O                  27   CCY                101
     O                  27                      102 '-'
     O                  27   CNUM               108
     O                  27                      109 '-'
     O                  27   ACOD               119
     O                  27                      120 '-'
     O                  27   ACSQ               122
     O                 N27   ACNO               110
      *
     O          E    89 84                    23
     O         AND   79                                                         LUC108
     O                       LSTDN              104
     O                                          106 '-'
     O                       RUNA               116
      *
     O          E    89 84                    25
     O         AND   79                                                         LUC108
     O                       STPA          3     85
     O                       STPP          3    110
      *
     O          E    87 84                    30
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O                                           41 'BALANCE B/F'
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O                  83                      119 'DR'
      *
     O          E    87 84 10            1
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    40 51 04DET         1
     O         AND     N12 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                                           25 'DR'
     O                     22                    25 'CR'
     O                                           40 'RATE CHG TO'
     O                       INTR                53 '  0 .       -'
     O                                           54 '%'
      *
     O          E    40 51N04DET         1
     O         AND         84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                       PNAR                55
     O************  N25                          47 ' CK'                       LUC133
     O***********   N25      CHQN                55                             LUC133
     O              N25NKP                       47 ' CK'                       LUC133
     O              N25NKP   CHQN                55                             LUC133
     O                  23 70PSTA                75 ' ,   ,   ,   , 0 '
     O                  23 71PSTA                75 '   ,   ,   , 0 . '
     O                  23 72PSTA                75 '  ,   ,   , 0 .  '
     O                  23 73PSTA                75 ' ,   ,   , 0 .   '
     O                  23                       77 'DR'
     O                  22 70PSTA                83 ' ,   ,   ,   , 0 '
     O                  22 71PSTA                83 '   ,   ,   , 0 . '
     O                  22 72PSTA                83 '  ,   ,   , 0 .  '
     O                  22 73PSTA                83 ' ,   ,   , 0 .   '
     O                  22                       85 'CR'
      *
     O          E    40 51N04DET         1
     O         AND      84 78
     O         AND   79                                                         LUC108
     O                       ROCCY               28
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '
     O                     KHROAMT               49 '   ,   ,   , 0 .   '
      *
     O          E       40 19TOT              54
     O         AND  N18 52 84
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70CLBL1              119 '   ,   ,   ,   , 0 CR'
     O                     71CLBL1              119 '  ,   ,   ,   , 0 . CR'
     O                     72CLBL1              119 ' ,   ,   ,   , 0 .  CR'
     O                     73CLBL1              119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E       40 19TOT              55
     O         AND  N18 52 84
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 40 18TOT              55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 40 18TOT         1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 40 18TOT              55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E    84 40 18TOT              58
     O         AND     N16
     O         AND   79                                                         LUC108
     O                                           29 'CURRENT PRIME RATE AS AT'
     O                       RUNA                37
     O                                           39 ':'
     O                       G@BRTE              53 ' , 0 .       '
      *
     O          E    84 40 19TOT              58
     O         AND  N18 52N16
     O         AND   79                                                         LUC108
     O                                           29 'CURRENT PRIME RATE AS AT'
     O                       RUNA                37
     O                                           39 ':'
     O                       G@BRTE              53 ' , 0 .       '
      *
     O          E    84 40 18TOT              16
     O         AND     N33
     O         AND   79                                                         LUC108
     O                  36   @WCNA1              62
     O                  35                       91 'DEMAND STATEMENT'
      *
     O          E    84 40 18TOT              17
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     36@WCNA2              62
      *
     O          E    84 40 18TOT              18
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     36@WCNA3              62
      *
     O          E    84 40 18TOT              19
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     36@WCNA4              62
      *
     O          E    84 40 18TOT              30
     O         AND     N33
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O                                           41 'BALANCE B/F'
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 40 18TOT         1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 40 45ENDPG            54
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           45 'CARRIED FORWARD'
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 40 45ENDPG       1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    46 40 52TOT              54
     O         AND         84
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70PSTAVL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTAVL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTAVL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTAVL             119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E    84 40 52TOT              55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 40 52TOT         1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 40 52TOT              58
     O         AND     N33
     O         AND   79                                                         LUC108
     O                 N16                       29 'CURRENT PRIME RATE AS AT'
     O                 N16   RUNA                37
     O                 N16                       39 ':'
     O                 N16   G@BRTE              53 ' , 0 .       '
     O                     70PSDR               119 ' ,   ,   ,   , 0 '
     O                     71PSDR               119 '   ,   ,   , 0 . '
     O                     72PSDR               119 '  ,   ,   , 0 .  '
     O                     73PSDR               119 ' ,   ,   , 0 .   '
      *
     O          E    84 40 52TOT              60
     O         AND   79                                                         LUC108
     O                     70PSCR               119 ' ,   ,   ,   , 0 '
     O                     71PSCR               119 '   ,   ,   , 0 . '
     O                     72PSCR               119 '  ,   ,   , 0 .  '
     O                     73PSCR               119 ' ,   ,   , 0 .   '
      *
     O          E    84 40 45ENDPG            55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E            ERPT1       1    03
     O         AND   79                                                         LUC108
     O                                           66 '*** END OF REPORT '
     O                  58                       77 'FOR BRANCH '
     O                  58   BRCASV              80
     O                  58                       84 ' ***'
     O                 N58                       69 '***'
      *
      *
      *    GL0420P4BEGINS    H E R E
      *                      -------
      *
     OGL0420P4  E    64 84                    01
     O         AND   79                                                         LUC108
     O                       FICHE               16
      *
     O          E    65 84                    16
     O         AND   79                                                         LUC108
     O                     36@WCNA1              62
     O                     35                    86 'DEMAND STATEMENT'
     O                       ANAM               117
      *
     O          E    65 84                    17
     O         AND   79                                                         LUC108
     O                     36@WCNA2              62
      *
     O          E    65 84                    18
     O         AND   79                                                         LUC108
     O                     36@WCNA3              62
      *
     O          E    65 84                    19
     O         AND   79                                                         LUC108
     O                     36@WCNA4              62
     O                       CCY                 87
     O                     27BRCA                97
     O                     27                    98 '-'
     O                     27CCY                101
     O                     27                   102 '-'
     O                     27CNUM               108
     O                     27                   109 '-'
     O                     27ACOD               119
     O                     27                   120 '-'
     O                     27ACSQ               122
     O                    N27ACNO               110
      *
     O          E    65 84                    23
     O         AND   79                                                         LUC108
     O                       LSTDN              104
     O                                          106 '-'
     O                       RUNA               116
      *
     O          E    65 84                    25
     O         AND   79                                                         LUC108
     O                       STPA          3     85
     O                       STPP          3    110
      *
     O          E    64 84                    30
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O****************************************   41 'BALANCE B/F'               LUC133
     O              NKP                          41 'BALANCE B/F'               LUC133
     O               KP                          41 'BALANCE FORWARD'           LUC133
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O                  83                      119 'DR'
      *
     O          E    64 84 10            1
     O         AND   79                                                         LUC108
     O                       BKEURO              80
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O                  83                      120 'DR)'
      *
     O          E    43 51 04DET         1
     O         AND     N12 84
     O*******  AND   79                                                  LUC108 LUC133
     O         AND   79 34                                                      LUC133
     O                       PSTDA               14
     O                                           25 'DR'
     O                     22                    25 'CR'
     O                                           40 'RATE CHANGE TO'
     O                       INTR                53 '  0 .       -'
     O                                           54 '%'
      *
     O          E    43 51 04DET         1                                       LUC133
     O         AND  N12 84N34                                                    LUC133
     O         AND   79 KP                                                       LUC133
     O                                                                           LUC133
     O                       PSTDA               14                              LUC133
     O                     69VALDA               23                              LUC133
     O                                           25 'DR'                         LUC133
     O                     22                    25 'CR'                         LUC133
     O                                           40 'RATE CHANGE TO'             LUC133
     O                       INTR                53 '  0 .       -'              LUC133
     O                                           54 '%'                          LUC133
      *
     O          E    43 51N04DET         1
     O         AND      84
     O******** AND   79                                                  LUC108 LUC133
     O         AND   79 34                                                      LUC133
     O                       PSTDA               14
     O                       PNAR                55
     O                  23 70PSTA                75 ' ,   ,   ,   , 0 '
     O                  23 71PSTA                75 '   ,   ,   , 0 . '
     O                  23 72PSTA                75 '  ,   ,   , 0 .  '
     O                  23 73PSTA                75 ' ,   ,   , 0 .   '
     O                  23                       77 'DR'
     O                  22 70PSTA                83 ' ,   ,   ,   , 0 '
     O                  22 71PSTA                83 '   ,   ,   , 0 . '
     O                  22 72PSTA                83 '  ,   ,   , 0 .  '
     O                  22 73PSTA                83 ' ,   ,   , 0 .   '
     O                  22                       85 'CR'
      *
     O          E    43 51N04DET         1                                      LUC133
     O         AND      84N34                                                   LUC133
     O         AND   79 KP                                                      LUC133
     O                       PSTDA               14                             LUC133
     O                     69VALDA               23                             LUC133
     O                       PNAR                55                             LUC133
     O                  23 70PSTA                75 ' ,   ,   ,   , 0 '         LUC133
     O                  23 71PSTA                75 '   ,   ,   , 0 . '         LUC133
     O                  23 72PSTA                75 '  ,   ,   , 0 .  '         LUC133
     O                  23 73PSTA                75 ' ,   ,   , 0 .   '         LUC133
     O                  23                       77 'DR'                        LUC133
     O                  22 70PSTA                83 ' ,   ,   ,   , 0 '         LUC133
     O                  22 71PSTA                83 '   ,   ,   , 0 . '         LUC133
     O                  22 72PSTA                83 '  ,   ,   , 0 .  '         LUC133
     O                  22 73PSTA                83 ' ,   ,   , 0 .   '         LUC133
     O                  22                       85 'CR'                        LUC133
     O                     70RUNBAL             116 '   ,   ,   ,   , 0 '       LUC133
     O                     71RUNBAL             116 '  ,   ,   ,   , 0 . '      LUC133
     O                     72RUNBAL             116 ' ,   ,   ,   , 0 .  '      LUC133
     O                     73RUNBAL             116 '   ,   ,   , 0 .   '       LUC133
     O                  09                      118 'DR'                        LUC133
     O                 N09                      118 'CR'                        LUC133
     O          E    43 51N04DET         1
     O         AND      84 78
     O         AND   79                                                         LUC108
     O                       ROCCY               28
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '
     O                     KHROAMT               49 '   ,   ,   , 0 .   '
      *
     O          E    43 45   ENDPG            54
     O         AND      84
     O         AND     N33
     O         AND   79                                                         LUC108
     O*************************************      45 'CARRIED FORWARD'           LUC133
     O              NKP                          45 'CARRIED FORWARD'           LUC133
     O               KP                          90 'CARRIED FORWARD'           LUC133
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    43 52   TOT              54
     O         AND  N33 84
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70CLBL1              119 '   ,   ,   ,   , 0 CR'
     O                     71CLBL1              119 '  ,   ,   ,   , 0 . CR'
     O                     72CLBL1              119 ' ,   ,   ,   , 0 .  CR'
     O                     73CLBL1              119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E    43 45   ENDPG       1
     O         AND      84
     O         AND  N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              80
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 43 52TOT              55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 43 52TOT         1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              80
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 43 45ENDPG            55
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E       43 52TOT              58                                 LUC133
     O         AND     N34 84                                                    LUC133
     O         AND   KPN33                                                       LUC133
     O         AND   79                                                          LUC133
     O                     70PSDR               118 ' ,   ,   ,   , 0 '          LUC133
     O                     71PSDR               118 '   ,   ,   , 0 . '          LUC133
     O                     72PSDR               118 '  ,   ,   , 0 .  '          LUC133
     O                     73PSDR               118 ' ,   ,   , 0 .   '          LUC133
     O          E       43 52TOT              60                                 LUC133
     O         AND     N34 84                                                    LUC133
     O         AND   KPN33                                                       LUC133
     O         AND   79                                                          LUC133
     O                     70PSCR               118 ' ,   ,   ,   , 0 '          LUC133
     O                     71PSCR               118 '   ,   ,   , 0 . '          LUC133
     O                     72PSCR               118 '  ,   ,   , 0 .  '          LUC133
     O                     73PSCR               118 ' ,   ,   , 0 .   '          LUC133
      *
     O          E    84 43 52TOT              58
     O         AND  N33N16
     O         AND   79                                                         LUC108
     O                                           29 'CURRENT PRIME RATE AS AT'
     O                       RUNA                37
     O                                           39 ':'
     O                       G@BRTE              53 ' , 0 .       '
      *
     O          E            ERPT4       1    03
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           66 '*** END OF REPORT '
     O                  58                       77 'FOR BRANCH '
     O                  58   BRCASV              80
     O                  58                       84 ' ***'
     O                 N58                       69 '***'
      *
      *    GL0420P5BEGINS    H E R E
      *                      -------
      *
     OGL0420P5  E       66 84                 01
     O         AND   79                                                         LUC108
     O                       FICHE               16
      *
     O          E       67 84                 16
     O         AND   79                                                         LUC108
     O                  36   @WCNA1              62
     O                  35                       86 'DEMAND STATEMENT'
     O                       ANAM               117
      *
     O          E    67 84                    17
     O         AND   79                                                         LUC108
     O                     36@WCNA2              62
      *
     O          E    67 84                    18
     O         AND   79                                                         LUC108
     O                     36@WCNA3              62
      *
     O          E    67 84                    19
     O         AND   79                                                         LUC108
     O                     36@WCNA4              62
     O                       CCY                 87
     O                     27BRCA                97
     O                     27                    98 '-'
     O                     27CCY                101
     O                     27                   102 '-'
     O                     27CNUM               108
     O                     27                   109 '-'
     O                     27ACOD               119
     O                     27                   120 '-'
     O                     27ACSQ               122
     O                    N27ACNO               110
      *
     O          E    67 84                    23
     O         AND   79                                                         LUC108
     O                       LSTDN              104
     O                                          106 '-'
     O                       RUNA               116
      *
     O          E    67 84                    25
     O         AND   79                                                         LUC108
     O                       STPA          3     85
     O                       STPP          3    110
      *
     O          E    66 84                    30
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O                                           41 'BALANCE B/F'
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O               83                         119 'DR'
      *
     O          E    66 84 10            1
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O               83                         120 'DR)'
      *
     O          E    44 51 04DET         1
     O         AND     N12 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                                           25 'DR'
     O                     22                    25 'CR'
     O                                           40 'RATE CHG TO'
     O                       INTR                53 '  0 .       -'
     O                                           54 '%'
      *
     O          E    44 51N04DET         1
     O         AND         84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                       PNAR                55
     O                  23 70PSTA                75 ' ,   ,   ,   , 0 '
     O                  23 71PSTA                75 '   ,   ,   , 0 . '
     O                  23 72PSTA                75 '  ,   ,   , 0 .  '
     O                  23 73PSTA                75 ' ,   ,   , 0 .   '
     O                  23                       77 'DR'
     O                  22 70PSTA                83 ' ,   ,   ,   , 0 '
     O                  22 71PSTA                83 '   ,   ,   , 0 . '
     O                  22 72PSTA                83 '  ,   ,   , 0 .  '
     O                  22 73PSTA                83 ' ,   ,   , 0 .   '
     O                  22                       85 'CR'
      *
     O          E    44 51N04DET         1
     O         AND      84 78
     O         AND   79                                                         LUC108
     O                       ROCCY               28
     O                     KEROAMT               49 '   ,   ,   ,   , 0 '
     O                     KFROAMT               49 '  ,   ,   ,   , 0 . '
     O                     KGROAMT               49 ' ,   ,   ,   , 0 .  '
     O                     KHROAMT               49 '   ,   ,   , 0 .   '
      *
     O          E    84 44 45ENDPG            54
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           45 'CARRIED FORWARD'
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 44 45ENDPG       1
     O         AND  N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E       44 52TOT              54
     O         AND     N33 84
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70CLBL1              119 '   ,   ,   ,   , 0 CR'
     O                     71CLBL1              119 '  ,   ,   ,   , 0 . CR'
     O                     72CLBL1              119 ' ,   ,   ,   , 0 .  CR'
     O                     73CLBL1              119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E    84 44 52TOT              55
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E    84 44 52TOT         1
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              79
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E    84 44 45ENDPG            55
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E    84 44 52TOT              58
     O         AND     N33N16
     O         AND   79                                                         LUC108
     O                                           29 'CURRENT PRIME RATE AS AT'
     O                       RUNA                37
     O                                           39 ':'
     O                       G@BRTE              53 ' , 0 .       '
      *
     O          E            ERPT5      02    03
     O         AND  N33
     O         AND   79                                                         LUC108
     O                                           66 '*** END OF REPORT '
     O               58                          77 'FOR BRANCH '
     O               58      BRCASV              80
     O               58                          84 ' ***'
     O              N58                          69 '***'
      *
      *    GL0420P6BEGINS    H E R E
      *                      -------
      *
     OGL0420P6  E    80 84                    01
     O         AND   79                                                         LUC108
     O                       FICHE               16
      *
     O          E    80 84                    16
     O         AND   79                                                         LUC108
     O                       @WCNA1              62
     O                                           86 '*MANAGEMENT STATEMENT*'
     O                       ANAM               117
      *
     O          E    81 84                    17
     O         AND   79                                                         LUC108
     O                       @WCNA2              62
      *
     O          E    81 84                    18
     O         AND   79                                                         LUC108
     O                       @WCNA3              62
      *
     O          E    81 84                    19
     O         AND   79                                                         LUC108
     O                       @WCNA4              62
     O                       CCY                 87
     O                     27BRCA                97
     O                     27                    98 '-'
     O                     27CCY                101
     O                     27                   102 '-'
     O                     27CNUM               108
     O                     27                   109 '-'
     O                     27ACOD               119
     O                     27                   120 '-'
     O                     27ACSQ               122
     O                    N27ACNO               110
      *
     O          E    81 84                    23
     O         AND   79                                                         LUC108
     O                       LSTDN              104
     O                                          106 '-'
     O                       RUNA               116
      *
     O          E    81 84                    25
     O         AND   79                                                         LUC108
     O                       STPA          3     85
     O                       STPP          3    110
      *
     O          E    80 84                    30
     O         AND   79                                                         LUC108
     O                       LSTDA               14
     O                                           41 'BALANCE B/F'
     O                     70PSTBF              119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBF              119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBF              119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBF              119 '   ,   ,   , 0 .   CR'
     O                  83                      119 'DR'
      *
     O          E    80 84 10            1
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBF              120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBF              120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBF              120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBF              120 '   ,   ,   , 0 .   CR)'
     O                  83                      120 'DR)'
      *
     O          E    41 51 34DET         1
     O         AND  N12 04 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                                           25 'DR'
     O                     22                    25 'CR'
     O                                           40 'RATE CHG TO'
     O                       INTR                53 '  0 .       -'
     O                                           54 '%'
      *
     O          E    41 51 34DET         1
     O         AND     N04 84
     O         AND   79                                                         LUC108
     O                       PSTDA               14
     O                     69VALDA               22
     O                       PNAR                55
     O************  N25                          47 ' CK'                       LUC133
     O***********   N25      CHQN                55                             LUC133
     O              N25NKP                       47 ' CK'                       LUC133
     O              N25NKP   CHQN                55                             LUC133
     O                  23 70PSTA                75 ' ,   ,   ,   , 0 '
     O                  23 71PSTA                75 '   ,   ,   , 0 . '
     O                  23 72PSTA                75 '  ,   ,   , 0 .  '
     O                  23 73PSTA                75 ' ,   ,   , 0 .   '
     O                  23                       77 'DR'
     O                  22 70PSTA                83 ' ,   ,   ,   , 0 '
     O                  22 71PSTA                83 '   ,   ,   , 0 . '
     O                  22 72PSTA                83 '  ,   ,   , 0 .  '
     O                  22 73PSTA                83 ' ,   ,   , 0 .   '
     O                  22                       85 'CR'
      *
     O          E    41 51 34DET         1
     O         AND  N04 84 78
     O         AND   79                                                         LUC108
     O                       ROCCY               33
     O                     KEROAMT               54 '   ,   ,   ,   , 0 '
     O                     KFROAMT               54 '  ,   ,   ,   , 0 . '
     O                     KGROAMT               54 ' ,   ,   ,   , 0 .  '
     O                     KHROAMT               54 '   ,   ,   , 0 .   '
      *
     O          E       41 45ENDPG            54
     O         AND      34 84
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           45 'CARRIED FORWARD'
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E       41 45ENDPG       1
     O         AND      34 84
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E       41 52TOT              54
     O         AND   34N33 84
     O         AND   79                                                         LUC108
     O                                           67 'AVAILABLE AMOUNT'
     O                     70CLBL1              119 '   ,   ,   ,   , 0 CR'
     O                     71CLBL1              119 '  ,   ,   ,   , 0 . CR'
     O                     72CLBL1              119 ' ,   ,   ,   , 0 .  CR'
     O                     73CLBL1              119 '   ,   ,   , 0 .   CR'
     O                     24                   119 'DR'
      *
     O          E       41 52TOT              55
     O         AND      34 84
     O         AND     N33
     O         AND   79                                                         LUC108
     O                     70PSTBAL             119 '   ,   ,   ,   , 0 CR'
     O                     71PSTBAL             119 '  ,   ,   ,   , 0 . CR'
     O                     72PSTBAL             119 ' ,   ,   ,   , 0 .  CR'
     O                     73PSTBAL             119 '   ,   ,   , 0 .   CR'
     O                     47                   119 'DR'
      *
     O          E       41 52TOT         1
     O         AND      34 84
     O         AND     N33 10
     O         AND   79                                                         LUC108
     O                       BKEURO              57
     O                                           97 '('
     O                     KAEUPBAL             120 '   ,   ,   ,   , 0 CR)'
     O                     KBEUPBAL             120 '  ,   ,   ,   , 0 . CR)'
     O                     KCEUPBAL             120 ' ,   ,   ,   , 0 .  CR)'
     O                     KDEUPBAL             120 '   ,   ,   , 0 .   CR)'
     O                     47                   120 'DR)'
      *
     O          E       41 45ENDPG            55
     O         AND      34 84
     O         AND   79                                                         LUC108
     O                                          116 '- CONTD'
      *
     O          E    84 41 52TOT              58
     O         AND  N33 34N16
     O         AND   79                                                         LUC108
     O                                           29 'CURRENT PRIME RATE AS AT'
     O                       RUNA                37
     O                                           39 ':'
     O                       G@BRTE              53 ' , 0 .       '
      *
     O          E            ERPT6       1    03
     O         AND     N33
     O         AND   79                                                         LUC108
     O                                           66 '*** END OF REPORT '
     O                  58                       77 'FOR BRANCH '
     O                  58   BRCASV              80
     O                  58                       84 ' ***'
     O                 N58                       69 '***'
      *
      *    GL0420AU  BEGINS  H E R E
      *                      -------
      *
     OGL0420AU  T       LR                  2  2
     O         AND   79                                                         LUC108
     O                                           24 'REFERENCE GL0420AU'
     O                       BJURPT              92
     O                                          104 'DATE'
     O                       RUNA               113
     O                                          122 'PAGE'
     O                       PAGE1              127
      *
     O          T       LR                  1
     O         AND   79                                                         LUC108
     O                                           70 'BALANCE STATEMENTS'
     O                                           85 'RUN CONTROLS'
      *
     O          T       LR                        1
     O         AND   79                                                         LUC108
     O                                           70 '------------------'
      *
     O          T       LR                    15
     O         AND   79                                                         LUC108
     O                                           30 'FILE CONTROLS'
     O                                           58 'INPUT'
     O                                           81 'CALCULATED'
      *
     O          T       LRNU7                 17
     O         AND   79                                                         LUC108
     O                                           31 'NO. STATEMENTS'
     O                                           45 'RECORDS READ:'
     O                       TNAR          3     84
      *
     O          T    U7 U8 LR            3
     O         AND   79                                                         LUC108
     O                                           42 '***REFERENCE'
     O                       DBPGM               53
     O                                           71 'DATABASE ERROR AT'
     O                       DBASE               75
      *
     O          T    U7 U8 LR            2  2
     O         AND   79                                                         LUC108
     O                                           37 'FILE NAME'
     O                       DBFILE              46
     O                                           51 'KEY'
     O                       DBKEY               81
      *
      *****************************************************************
      * End of /COPY GL0420OOP1                                       *
      *****************************************************************
