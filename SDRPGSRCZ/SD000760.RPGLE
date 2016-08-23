     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Performance incentive fees initialisation')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000760 - Initialisation Program for Feature CSD011         *
      *                                                               *
      *  Function:  This program defaults the value of the new fields *
      *             introduced by CSD011 in files SDTOFPD and         *
      *             SDCFTPPD.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSD011  *CREATE    Date 11Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD011 - Performance Incentive Fees enhancements.            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    80         Read SDTOFPD TOF ICD Physical File              *
      *    85         Read SDCFTPPD Fee Type Physical File            *
      *    86         Read GLCHRGPD Customer Fee Charges              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * MPROC      - Main Processing                                  *
      * END        - Exit fron program                                *
      * *INZSR     - Initialise                                       *
      * *PSSR      - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** TOF ICD Physical File.
     FSDTOFPD   UF   E             DISK    INFSR(*PSSR)
      *
      ** Fee Type Physical File.
     FSDCFTPPD  UF   E             DISK    INFSR(*PSSR)
      *
      ** Fee Charges Physical File.
     FGLCHRGPD  UF   E             DISK    INFSR(*PSSR)
      *
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Externally described DS for switchable feature details
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** INZSR - Initial Processing
      *
      ** Execute  Main Processing
     C                   EXSR      MPROC
      *
      ** Exit from program
     C                   EXSR      END
      *
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MPROC - Main Processing                                      *
      *                                                               *
      *****************************************************************
      *
     C     MPROC         BEGSR
      *
      ** Default the new field TQIFNB, introduced by Switchable feature
      ** CSD011, in file SDTOFPD to value 05.
      *
     C                   READ      SDTOFPD                                80
      *
     C     *IN80         DOWEQ     '0'
      *
     C     TQIFNB        IFEQ      *ZEROS
     C                   Z-ADD     05            TQIFNB
     C                   UPDATE    SDTODPF
     C                   END
     C                   READ      SDTOFPD                                80
      *
     C                   END
      *
      ** Default the new fields introduced by CSD011 in File SDCFTPPD.
      *
     C                   READ      SDCFTPPD                               85
      *
     C     *IN85         DOWEQ     '0'
      *
     C                   MOVE      *BLANKS       F1EXPO                         Fee on Excess
     C                   MOVE      *BLANKS       F1BASP                         Basis For P Val
     C                   Z-ADD     *ZEROS        F1DAYM                         Days in Month
     C                   Z-ADD     *ZEROS        F1MONQ                         Month in Quarter
     C                   MOVE      'N'           F1WAIV                         Waive Minimum
      *
     C                   UPDATE    SDCFTPD0
     C                   READ      SDCFTPPD                               85
      *
     C                   END
      *
      ** Default the new fields introduced by CSD011 in File GLCHRGPD.
      *
     C                   READ      GLCHRGPD                               86
      *
     C     *IN86         DOWEQ     '0'
      *
     C                   MOVE      *BLANKS       CHHWMF
     C                   MOVE      *BLANKS       CHCFRE
     C                   Z-ADD     0             CHCDMO
     C                   Z-ADD     0             CHNCDA
      *
     C                   UPDATE    GLCHRGD0
     C                   READ      GLCHRGPD                               86
      *
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  EXIT - Exit from program                                     *
      *                                                               *
      *****************************************************************
      *
     C     END           BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
