     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Get extract control information')             *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEGETEXCT - Get Extract Control Information.                 *
      *                                                               *
      *  Function:  This module retrieves all extract control dates   *
      *             and period end dates for the various extraction   *
      *             processes.                                        *
      *                                                               *
      *  Component of: DEPXCACCT, DEPXCCFCO, DEPXCFRAS, DEPXCFXDL,    *
      *                DEPXCLDNI, DEPXCLOAN, DEPXCNASP, DEPXCOTCC,    *
      *                DEPXCSBPS, DEPXCSWAP                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 16Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D PeriodEDT     E DS                  EXTNAME(DEPPERDPD)
 
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
                                                                                              CDE002
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                  CDE002
      ** External DS for BANK details                                                         CDE002
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CDE002
      ** External DS for Switchable Features details                                          CDE002
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE002
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CDE002
 
 
     C     *ENTRY        PLIST
 
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
 
      * INPUTS
     C                   PARM                    Proj_Hist         1
     C                   PARM                    EndofBook         1
      * OUTPUTS
     C                   PARM                    Run_Date          5 0
     C                   PARM                    Date_NWD          5 0
                                                                                              CDE002
     C                   PARM                    HistCO_Dat        5 0
     C**********         PARM                    Extrct_Dat        5 0                        CDE002
     C                   PARM                    EvtCtl_Dat        5 0
     C                   PARM                    ProjCO_Dat        5 0
                                                                                              CDE002
     C                   PARM                    PeriodEDT
     C                   PARM                    DataArea        128                          208221
 
      ** Read Extract Control Data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C                   IN        DEEXTCTL
     C                   MOVEL     DEEXTCTL      DataArea                                     208221
      *                                                                                       CDE002
      **  Access Bank Details                                                                 CDE002
      *                                                                                       CDE002
     C                   CALLB     'AOBANKR0'                                                 CDE002
     C                   PARM      '*DBERR  '    @RTCD             7                          CDE002
     C                   PARM      '*FIRST  '    @OPTN             7                          CDE002
     C     SDBANK        PARM      SDBANK        DSFDY                                        CDE002
      *                                                                                       CDE002
      **  Access General Ledger details                                                       CDE002
      *                                                                                       CDE002
     C**********         CALLB     'AOGELRR0'                                          CDE002 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7                          CDE002
     C                   PARM      '*FIRST  '    @OPTN             7                          CDE002
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CDE002 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
                                                                                              CDE002
      * If this is a 'PROJECTED - TO END OF BOOK' extract                                     CDE002
      * =================================================                                     CDE002
                                                                                              CDE002
     C                   SELECT                                                               CDE002
     C     Proj_Hist     WHENEQ    'P'                                                        CDE002
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
                                                                                              CDE002
      * Set the run date, date of next working day and                                        CDE002
      * projections cut-off date                                                              CDE002
                                                                                              CDE002
     C                   Z-ADD     DEPRDNB       Run_Date                                     CDE002
     C                   Z-ADD     DEPDNWD       Date_NWD                                     CDE002
     C                   Z-ADD     DEPCDT        ProjCO_Dat                                   CDE002
                                                                                              CDE002
      * Get the 'Projected' Period End Dates                                                  CDE002
                                                                                              CDE002
     C                   EXSR      GET_PEREDT                                                 CDE002
                                                                                              CDE002
      * If this is a 'PROJECTED - NOT TO END OF BOOK' extract                                 CDE002
      * =====================================================                                 CDE002
                                                                                              CDE002
     C     Proj_Hist     WHENEQ    'P'                                                        CDE002
     C     EndofBook     ANDEQ     'N'                                                        CDE002
                                                                                              CDE002
      * Set the run date, date of next working day                                            CDE002
      * and event control date                                                                CDE002
                                                                                              CDE002
     C                   Z-ADD     BJRDNB        Run_Date                                     CDE002
     C                   Z-ADD     BJDNWD        Date_NWD                                     CDE002
     C     BJDNWD        IFLE      BKAPDT                                                     CDE002
     C     BJDNWD        SUB       1             EvtCtl_Dat                                   CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     BKAPDT        EvtCtl_Dat                                   CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
      * Use just one Period End Date = Event Control Date                                     CDE002
                                                                                              CDE002
     C                   CLEAR                   PeriodEDT                                    CDE002
     C                   Z-ADD     EvtCtl_Dat    W#D001                                       CDE002
                                                                                              CDE002
      * If this is a 'HISTORIC' extract                                                       CDE002
      * ===============================                                                       CDE002
                                                                                              CDE002
     C     Proj_Hist     WHENEQ    'H'                                                        CDE002
                                                                                              CDE002
      * Set the run date, date of next working day,                                           CDE002
      * history cut-off date and event control date                                           CDE002
                                                                                              CDE002
     C                   Z-ADD     DEHRDNB       Run_Date                                     CDE002
     C                   Z-ADD     DEHDNWD       Date_NWD                                     CDE002
     C                   Z-ADD     DEHCDT        HistCO_Dat                                   CDE002
     C     DEHDNWD       SUB       1             EvtCtl_Dat                                   CDE002
                                                                                              CDE002
      * Get the 'Historic' Period End Dates                                                   CDE002
                                                                                              CDE002
     C                   EXSR      GET_PEREDT                                                 CDE002
                                                                                              CDE002
     C                   ENDSL                                                                CDE002
      *                                                                                       CDE002
      * Return                                                                                CDE002
      *                                                                                       CDE002
     C                   SETON                                        LR                      CDE002
     C                   RETURN                                                               CDE002
                                                                                              CDE002
                                                                                              CDE002
 
      **If*this*is*a*'PROJECTED'*extract*******************************                       CDE002
      **********                                                                              CDE002
     C*****Proj_Hist     IFEQ      'P'                                                        CDE002
      **********                                                                              CDE002
      **Set*run*date*and*date*of*next*working*day**********************                       CDE002
      **********                                                                              CDE002
     C**********         Z-ADD     DEPRDNB       Run_Date                                     CDE002
     C**********         Z-ADD     DEPDNWD       Date_NWD                                     CDE002
      **********                                                                              CDE002
      **If*the*extract*is*to*end*of*book*******************************                       CDE002
      **********                                                                              CDE002
     C*****EndofBook     IFEQ      'Y'                                                        CDE002
      **********                                                                              CDE002
      **The*extract*is*from*the*run*date*to*the*projected*cut-off*date*                       CDE002
      **********                                                                              CDE002
     C**********         Z-ADD     DEPRDNB       Extrct_Dat                                   CDE002
     C**********         Z-ADD     DEPCDT        ProjCO_Dat                                   CDE002
      **********                                                                              CDE002
      **Else,*the*extract*is*from*the*history*cut-off*date*************                       CDE002
      ********to*the*day*prior*to*the*next*working*day*****************                       CDE002
      **********                                                                              CDE002
     C**********         ELSE                                                                 CDE002
     C**********         Z-ADD     DEHCDT        Extrct_Dat                                   CDE002
     C*****DEPDNWD       SUB       1             ProjCO_Dat                                   CDE002
      **********                                                                              CDE002
     C**********         ENDIF                                                                CDE002
      **********                                                                              CDE002
      **Set*the*event*control*date*to*DNWD*-*1*************************                       CDE002
      **********                                                                              CDE002
     C*****DEPDNWD       SUB       1             EvtCtl_Dat                                   CDE002
      **********                                                                              CDE002
      **else*this*is*a*'HISTORIC'*extract******************************                       CDE002
      **********                                                                              CDE002
     C**********         ELSE                                                                 CDE002
      **********                                                                              CDE002
      **Set*run*date*and*date*of*next*working*day**********************                       CDE002
      **********                                                                              CDE002
     C**********         Z-ADD     DEHRDNB       Run_Date                                     CDE002
     C**********         Z-ADD     DEHDNWD       Date_NWD                                     CDE002
      **********                                                                              CDE002
      **The*extract*is*from*the*historic*cut-off*date*to*the*run*date**                       CDE002
      **********                                                                              CDE002
     C**********         Z-ADD     DEHCDT        HistCO_Dat                                   CDE002
     C**********         Z-ADD     DEHRDNB       Extrct_Dat                                   CDE002
      **********                                                                              CDE002
      **Set*the*event control date to DNWD - 1                                                CDE002
      **********                                                                              CDE002
     C*****DEHDNWD       SUB       1             EvtCtl_Dat                                   CDE002
      **********                                                                              CDE002
     C**********         ENDIF                                                                CDE002
      **********                                                                              CDE002
      **Get*the*projected period end dates                                                    CDE002
      **********                                                                              CDE002
     C**********         CALLB     'DEGETPERD'                                                CDE002
     C**********         PARM      *BLANK        W#RTCD            7            * RETURN CODE CDE002
     C**********         PARM      *BLANK        W#ERMS           30            * ERROR MESSAGCDE002
      **Inputs**                                                                              CDE002
     C**********         PARM                    Proj_Hist                                    CDE002
      **Outputs*                                                                              CDE002
     C**********         PARM                    PeriodEDT                                    CDE002
      **********                                                                              CDE002
     C*****W#RTCD        IFEQ      '*ERROR'                                                   CDE002
     C**********         EVAL      I#ERMS = 'ERROR IN CALL TO DEGETPERD'                      CDE002
     C**********         EXSR      *PSSR                                                      CDE002
     C**********         END                                                                  CDE002
      **********                                                                              CDE002
      **Return**                                                                              CDE002
      **********                                                                              CDE002
     C**********         SETON                                        LR                      CDE002
     C**********         RETURN                                                               CDE002
      *
      *********************************************************************
      /SPACE 5                                                                                CDE002
      *********************************************************************                   CDE002
      * GET THE PERIOD END DATES                                                              CDE002
      *********************************************************************                   CDE002
     C     GET_PEREDT    BEGSR                                                                CDE002
     C                   CALLB     'DEGETPERD'                                                CDE002
     C                   PARM      *BLANK        W#RTCD            7                          CDE002
     C                   PARM      *BLANK        W#ERMS           30                          CDE002
      * Inputs                                                                                CDE002
     C                   PARM                    Proj_Hist                                    CDE002
      * Outputs                                                                               CDE002
     C                   PARM                    PeriodEDT                                    CDE002
                                                                                              CDE002
     C     W#RTCD        IFEQ      '*ERROR'                                                   CDE002
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO DEGETPERD'                      CDE002
     C                   EXSR      *PSSR                                                      CDE002
     C                   END                                                                  CDE002
     C                   ENDSR                                                                CDE002
      *********************************************************************                   CDE002
      /SPACE 5
      *********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *********************************************************************
      /SPACE 5
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
