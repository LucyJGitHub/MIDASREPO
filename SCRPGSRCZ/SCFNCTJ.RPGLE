     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('API Interface using Unicode ZL Form, Driver')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCFNCTJ - API Interface using Unicode ZL Form, Driver        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      *  Last Amend No. CSC043             Date 18Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. BG13742 *CREATE    Date 17Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC043 - MidasPlus IASP Enablement                           *
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
     D p_Lib           S             10
     D p_Lib2          S             10
     D p_ZONE          S              2
     D Var_Parm        S             21
     D*p_Len           S             15P 5
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
     C                   Parm                    p_ZONE
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
      *
      *                                                                                       CSC043
      ** CSC043 - Programs are now located in 'XPLIB', not 'XLIB'.                            CSC043
      *                                                                                       CSC043
     C**********         Eval      P_Lib = P_Zone + 'XLIB'                                    CSC043
     C                   Eval      P_Lib = P_Zone + 'XPLIB'                                   CSC043
     C                   Eval      Var_Parm = P_Lib + '/' + 'SCFNCTJ2'
      *
     C                   Call      Var_Parm      FNCTJ
     C                   Return
