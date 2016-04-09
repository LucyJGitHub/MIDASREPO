     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('API Interface using Unicode ZL Form, Driver')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCFNCTJ2 - API Interface using Unicode ZL Form, Driver       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BG13742 *CREATE    Date 17Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG13742 - Authority problem on MidasPlus Equation interface  *
      *                                                               *
      *****************************************************************
      *
      *  Entry Parameters
     D pu_FIXEDIMAGE   S           9999c   VARYING
     D pu_LIST1        S           9999c   VARYING
     D pu_LIST2        S           9999c   VARYING
     D pu_LIST3        S           9999c   VARYING
     D pu_LIST4        S           9999c   VARYING
     D pu_LIST5        S           9999c   VARYING
     D pu_LIST6        S           9999c   VARYING
     D pu_LIST7        S           9999c   VARYING
     D pu_LIST8        S           9999c   VARYING
     D pu_LIST9        S           9999c   VARYING
     D pu_LIST10       S           9999c   VARYING
 
     D pu_listParm     s           9999c   VARYING BASED(pu_listPtr)
     D pu_listPtr      s               *
     D pu_listPtrArr   s               *   DIM(10)
 
     D pu_PVFILTER     S            256c   VARYING
     D pu_PVLIST1      S           9999c   VARYING
     D pu_PVLIST2      S           9999c   VARYING
     D pu_PVLIST3      S           9999c   VARYING
     D pu_PVLIST4      S           9999c   VARYING
     D pu_PVLIST5      S           9999c   VARYING
     D pu_PVLIST6      S           9999c   VARYING
     D pu_PVLIST7      S           9999c   VARYING
     D pu_PVLIST8      S           9999c   VARYING
     D pu_PVLIST9      S           9999c   VARYING
     D pu_PVLIST10     S           9999c   VARYING
 
     D pu_PVListParm   s           9999c   VARYING BASED(pu_PVListPtr)
     D pu_PVListPtr    s               *
     D pu_PVListPtrAr  s               *   DIM(10)
      *
     D p_DSCNTRL       S            128    VARYING
     D p_DSSUPER       S             64
     D p_DSINCRM       S            128    VARYING
     D p_MESSAGES      S           5000    VARYING
     D p_OVERRIDES     S           5000    VARYING
     D p_DSJRNKY       S             51    VARYING
     D p_EVENTKY       S            512    VARYING
     D p_BEFOREIMAGE   S           9999    VARYING
     D p_FIXEDIMAGE    S           9999    VARYING
     D p_DSLISTE       S             56    VARYING
     D p_FKEYS         S            600    VARYING
     D p_CRMWARNMSG    S           9999    VARYING
     D p_DSPVE         S             56    VARYING
     D p_FIELDSTATE    S           9997    VARYING
     DQUSEC            DS
      *                                             Qus EC
     D QUSBPRV                 1      4B 0
      *                                             Bytes Provided
     D QUSBAVL                 5      8B 0
      *                                             Bytes Available
     D QUSEI                   9     15
      *                                             Exception Id
     D QUSERVED               16     16
      *                                             Reserved
      *QUSED01                17     17
      *                                             Varying length
     D QUSExcData             17     46
      *                                             Varying length field Exception Data
     D Jobd            DS            20
     D JobDName                1     10    INZ('MIDASIC   ')
     D System                 11     12
     D XLib                   13     20    INZ('XLIB    ')
 
 
     D Parm            DS          1000
     D OffSetB               361    364B 0
     D LibCountB             365    368B 0
 
     D Len             S              4B 0 INZ(1000)
     D APIRetC         S              1
     D OffLen          S              9  0
     D OffSet          S              9  0
     D InLibl          S           2750
     D Command         S           2764
     D VarMsgArrO      S          32000    VARYING                                            BG1105
      *
     D Eq_DS           DS
     D   Lib1                  1     10
     D   Lib2                 12     21
     D   Lib3                 23     32
     D   Lib4                 34     43
     D   Lib5                 45     54
     D   Lib6                 56     65
     D   Lib7                 67     76
     D   Lib8                 78     87
     D   Lib9                 89     98
     D   Lib10               100    109
     D   Lib11               111    120
     D   Lib12               122    131
     D   Lib13               133    142
     D   Lib14               144    153
     D   Lib15               155    164
     D   Lib16               166    175
     D   Lib17               177    186
     D   Lib18               188    197
     D   Lib19               199    208
     D   Lib20               210    219
     D   Lib21               221    230
     D   Lib22               232    241
     D   Lib23               243    252
     D   Lib24               254    263
     D   Lib25               265    274
 
     D Var_Parm        S             21
     D P_Cmd           S            512
     D P_Len           S             15  5
      *
      *-------------------------------------------------------------------
      *  PARAMETER AND KEY LISTS
      *-------------------------------------------------------------------
      *
      *  Parameter lists
      *
      *  Entry
     C     *Entry        Plist
     C                   Parm                    p_DSCNTRL
     C                   Parm                    p_DSSUPER
30   c                   Parm                    p_DSINCRM
     C                   Parm                    p_MESSAGES
     C                   Parm                    p_OVERRIDES
     C                   Parm                    p_DSJRNKY
     C                   Parm                    p_EVENTKY
     C                   Parm                    p_BEFOREIMAGE
     C                   Parm                    pu_FIXEDIMAGE
     C                   Parm                    p_DSLISTE
     C                   Parm                    pu_LIST1
     C                   Parm                    pu_LIST2
     C                   Parm                    pu_LIST3
     C                   Parm                    pu_LIST4
     C                   Parm                    pu_LIST5
     C                   Parm                    pu_LIST6
     C                   Parm                    pu_LIST7
     C                   Parm                    pu_LIST8
     C                   Parm                    pu_LIST9
     C                   Parm                    pu_LIST10
     C                   Parm                    p_DSPVE
     C                   Parm                    pu_PVFILTER
     C                   Parm                    pu_PVLIST1
     C                   Parm                    pu_PVLIST2
     C                   Parm                    pu_PVLIST3
     C                   Parm                    pu_PVLIST4
     C                   Parm                    pu_PVLIST5
     C                   Parm                    pu_PVLIST6
     C                   Parm                    pu_PVLIST7
     C                   Parm                    pu_PVLIST8
     C                   Parm                    pu_PVLIST9
     C                   Parm                    pu_PVLIST10
     C                   Parm                    p_FIELDSTATE
     C                   Parm                    p_FKEYS
     C                   Parm                    p_CRMWARNMSG
      *
     C     FNCTJ         Plist
     C                   Parm                    p_DSCNTRL
     C                   Parm                    p_DSSUPER
30   c                   Parm                    p_DSINCRM
     C                   Parm                    p_MESSAGES
     C                   Parm                    p_OVERRIDES
     C                   Parm                    p_DSJRNKY
     C                   Parm                    p_EVENTKY
     C                   Parm                    p_BEFOREIMAGE
     C                   Parm                    pu_FIXEDIMAGE
     C                   Parm                    p_DSLISTE
     C                   Parm                    pu_LIST1
     C                   Parm                    pu_LIST2
     C                   Parm                    pu_LIST3
     C                   Parm                    pu_LIST4
     C                   Parm                    pu_LIST5
     C                   Parm                    pu_LIST6
     C                   Parm                    pu_LIST7
     C                   Parm                    pu_LIST8
     C                   Parm                    pu_LIST9
     C                   Parm                    pu_LIST10
     C                   Parm                    p_DSPVE
     C                   Parm                    pu_PVFILTER
     C                   Parm                    pu_PVLIST1
     C                   Parm                    pu_PVLIST2
     C                   Parm                    pu_PVLIST3
     C                   Parm                    pu_PVLIST4
     C                   Parm                    pu_PVLIST5
     C                   Parm                    pu_PVLIST6
     C                   Parm                    pu_PVLIST7
     C                   Parm                    pu_PVLIST8
     C                   Parm                    pu_PVLIST9
     C                   Parm                    pu_PVLIST10
     C                   Parm                    p_FIELDSTATE
     C                   Parm                    p_FKEYS
     C                   Parm                    p_CRMWARNMSG
 
     C                   Eval      Var_Parm = 'V36BASELIB' + '/' + 'EQFNCTJ'
 
     C                   Call      Var_Parm      FNCTJ
 
     C                   Return
