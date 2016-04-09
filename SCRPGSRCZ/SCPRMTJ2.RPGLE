     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('PV  Interface using Unicode ZL Form')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCPRMTJ2 - PV  Interface using Unicode ZL Form, Driver       *
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
      *  Entry Parameters
 
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
      *  EQPRMT Parameters
     D p_DSPVC         S             20    VARYING
     D p_DSPVI         S             40    VARYING
     D p_DSPVE         S             56    VARYING
     D p_PVFILTER      S            256    VARYING
     D p_PVLIST1       S           9999    VARYING
     D p_PVLIST2       S           9999    VARYING
     D p_PVLIST3       S           9999    VARYING
     D p_PVLIST4       S           9999    VARYING
     D p_PVLIST5       S           9999    VARYING
     D p_PVLIST6       S           9999    VARYING
     D p_PVLIST7       S           9999    VARYING
     D p_PVLIST8       S           9999    VARYING
     D p_PVLIST9       S           9999    VARYING
     D p_PVLIST10      S           9999    VARYING
 
     D p_PVListParm    s           9999    VARYING BASED(p_PVListPtr)
     D p_PVListPtr     s               *
     D p_PVListPtrArr  s               *   DIM(10)
 
     D p_CALLSTATUS    S              1
     D p_MESSAGEID     S              7
     D p_MESSAGETEXT   S            132    VARYING
 
     D Var_Parm        S             21
      *
      *
      *-------------------------------------------------------------------
      *  PARAMETER AND KEY LISTS
      *-------------------------------------------------------------------
      *
      *  Parameter lists
      *
      *  Entry
     C     *Entry        Plist
     C                   PARM                    p_DSPVC
29   C                   PARM                    p_DSPVI
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
     C                   PARM                    p_CALLSTATUS
     C                   PARM                    p_MESSAGEID
     C                   PARM                    p_MESSAGETEXT
      *
     C     PRMTJ         Plist
     C                   PARM                    p_DSPVC
29   C                   PARM                    p_DSPVI
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
     C                   PARM                    p_CALLSTATUS
     C                   PARM                    p_MESSAGEID
     C                   PARM                    p_MESSAGETEXT
      *
     C                   Eval      Var_Parm = 'V36BASELIB' + '/' + 'EQPRMTJ'
      *
     C                   Call      Var_Parm      PRMTJ
     C                   Return
