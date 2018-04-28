     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBNC                                                   *
/*EXI *  TEXT('Midas MR MBI/Almonde interface - housekeeping')        *
/*XBI *  OVRDBF LIBLIST UPOBJDTPD                                     *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001010 - MBI/Almonde interface - housekeeping              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CMR002  *CREATE    Date 14Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMR002 - MBI/Almonde Interface                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** DSPOBJD outfile listing all libraries beginnning with the zone prefix
     FLIBLIST   IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Parameters
     D PRtCd           S              7A
     D RtnPeriod       S              2S 0
 
      * Access object parameters
     D WRun            S              1A
     D POptn           S              7A
     D ObjType         S              7A
 
      * QCMDEXC parameters
     D Exec            S             20
     D CmdLen          S             15  5
 
      * Work variables
     D LibDate         S              8S 0
     D CompDate        S              5S 0
     D LibName         S             10A
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for User defined attribute
      ** Format -
      **   1-5  Literal 'MIDAS'
      **   6-10 Rundate when created
     D UserAttr        DS            10
     D MIDAS                   1      5
     D  CrtDate                6     10S 0
     D  CrtDateA               6     10
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Read through all libraries beginning with the System Prefix and
      ** determine if they are MBI libraries created before the retention
      ** period. if so, delete them.
     C     *LOVAL        SetLL     LIBLIST
 
     C                   Read      LIBLIST                                60
 
     C                   DoW       *In60 = *Off
 
      * If numeric, check if this is an MBI library and delete.
     C                   ExSR      CheckMBI
 
     C                   Read      LIBLIST                                60
     C                   EndDo
 
      ** End program
     C                   Eval      *InLR = *On
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * CheckMBI - Check if this is an MBI library and delete.        *
      *****************************************************************
     C     CheckMBI      BegSR
 
      ** Get the user defined attribute for the library
     C                   Reset                   UserAttr
     C                   Call      'ZACRTVUSRA'
     C                   Parm      *Blanks       PRtCd
     C                   Parm                    ODOBNM
     C                   Parm      '*LIB'        ObjType
     C                   Parm                    UserAttr
 
     C                   If        PRtCd  = '*ERROR'
     C                   ExSR      *PSSR
     C                   EndIf
     C
      ** First 5 characters should be 'MIDAS' next 5, a rundate
     C                   If        MIDAS = 'MIDAS'
     C                   TestN                   CrtDateA             61
     C                   If        *In61 = *On
 
      ** If creation date is less than retention date, delete
     C                   If        CrtDate < CompDate
      *
     C                   Eval      Exec = 'DLTLIB ' + ODOBNM
     C                   Call      'QCMDEXC'
     C                   Parm                    Exec
     C                   Parm                    CmdLen
     C                   EndIf
     C                   EndIf
     C                   EndIf
 
     C                   EndSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *****************************************************************
     C     *INZSR        BegSR
 
     C     *Entry        PList
     C                   Parm                    PRtCd
     C                   Parm                    RtnPeriod
 
      ** Access bank details
     C                   Call      'AOBANKR0'
     C                   Parm      '*MSG    '    PRtcd
     C                   Parm      '*FIRST  '    POptn
     C     SDBANK        Parm      SDBANK        DSFDY
     C     PRtcd         IfNE      *BLANK
     C                   MoveL     POptn         DBKEY
     C                   MoveL     'SDBANKPD'    DBFILE
     C                   Z-Add     1             DBASE
     C                   ExSR      *PSSR
     C                   EndIf
 
      ** Set up comparison rundate
     C                   Eval      CompDate = BJRDNB - RtnPeriod
 
      ** Set up QCMDEXC default
     C                   Eval      CmdLen = 20
 
     C                   EndSr
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *****************************************************************
     C     *PSSR         BegSR
 
     C                   If        WRun = *blanks
 
      * Prevent recursive errors
     C                   Move      'Y'           WRun
 
      * Set return code and dump the program
     C                   Eval      PRtCd   = '*Error*'
     C                   Dump
     C                   EndIf
 
      * Set job switches
     C                   Eval      *InLR = *On
 
      * End program
     C                   Return
 
     C                   EndSR
      *****************************************************************
