     **H***** DEBUG DATEDIT(*YMD)                                                             CAP084
     H DEBUG                                                                                  CAP084
      *****************************************************************
/*S*D ***RPGBASE*******************************************************                       CAP084
/*STD *  RPGBASEBND                                                   *                       CAP084
/*EXI *  DFTACTGRP(*NO) ACTGRP(*CALLER)                               *                       CAP084
/*EXI *  TEXT('Midas SD Prepare deleted record for audit')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD0520X - Prepare Deleted Record for Audit                   *
      *                                                               *
      *  Function:  This program copies a record to a holding file    *
      *             to make it available for auditing during COB.     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAP084             Date 16Jul03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD003             Date 27Oct97               *
      *                 122096  *CREATE    Date 22AUG97               *
      *                                                               *
      *-------------------------------------------------------------- *
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP084 - Wrapper project - convert to ILE                    *
      *  CSD003 - Synon Closedown Project (SD):                       *
      *           - Program removed from SD model.                    *
      *  122096 - New program.                                        *
      *                                                               *
      *****************************************************************
     F/COPY WNCPYSRC,SD0520XFPG
     FSDDELRL0  IF A E           K DISK    USROPN
     F                                     COMMIT
     F                                     INFDS(ID0001)
     F                                     INFSR(*PSSR)
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D*
     D/COPY WNCPYSRC,SD0520XEPG
     D/COPY WNCPYSRC,SD0520XIPG
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
     D ID0001          DS           528
      * File information data structure
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS          3064
      * RCD: Midas SD Deleted records file retrieval
      * I :  File name
     D  P1FNME                 1     10
      * I :  Long Key
     D  P1LKEY                11     60
      * I :  Deleted Data Record Pt1
     D  P1DR01                61    310
      * I :  Deleted Data Record Pt2
     D  P1DR02               311    560
      * I :  Deleted Data Record Pt3
     D  P1DR03               561    810
      * I :  Deleted Data Record Pt4
     D  P1DR04               811   1060
      * I :  Deleted Data Record Pt5
     D  P1DR05              1061   1310
      * I :  Deleted Data Record Pt6
     D  P1DR06              1311   1560
      * I :  Deleted Data Record Pt7
     D  P1DR07              1561   1810
      * I :  Deleted Data Record Pt8
     D  P1DR08              1811   2060
      * I :  Deleted Data Record Pt9
     D  P1DR09              2061   2310
      * I :  Deleted Data Record Pt10
     D  P1DR00              2311   2560
      * I :  Deleted Data Record Pt11
     D  P1DR11              2561   2810
      * I :  Deleted Data Record Pt12
     D  P1DR12              2811   3060
      * I :  Last Change Date
     D  P1LCD               3061   3063P 0
      * I :  Type of Last Change
     D  P1TYLC              3064   3064
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P1PARM                         RCD: SD Deleted
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Write Deleted Record
      * SD0520X Precompiler - SD Deleted Records File  *
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          ##MRDT            7            RUN DATE
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB                         RUNDAY NO.
     C                   MOVE      SUC           WUSUC                          SET UP COMPLT
     C                   MOVE      DFF           WUDFF                          DTE FMT FLAG
     C                   MOVE      MBIN          WUMBIN                         MULTI BR. IND
      * Copyright Statement 1997 - Standard Functions  * copyright
      * Create SD Deleted Records - SD Deleted Records File  *
     C                   EXSR      SACRRC
      * 00/Copy member SD0520XFPG - SD Deleted Records File  *
      * 00/Copy member SD0520XIPG - SD Deleted Records File  *
      * 00/Copy member SD0520XEPG - SD Deleted Records File  *
      * 00/Copy member SD0520XCPG - SD Deleted Records File  *
     C/COPY WNCPYSRC,SD0520XCPG
      *----------------------------------------------------------------
      * Exit program
     C     AAEXIT        TAG
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
      /EJECT
     CSR   SACRRC        BEGSR
      *================================================================
      * Create SD Deleted Records - SD Deleted Records File  *
      *================================================================
     C                   MOVEL     *BLANK        W0RTN             7
      * Move all fields to @DELRL0
     C                   MOVEL     P1FNME        GFFNME                         File name
     C                   MOVEL     P1LKEY        GFLKEY                         Long Key
     C                   MOVEL     P1DR01        GFDR01                         Deleted Data Re
     C                   MOVEL     P1DR02        GFDR02                         Deleted Data Re
     C                   MOVEL     P1DR03        GFDR03                         Deleted Data Re
     C                   MOVEL     P1DR04        GFDR04                         Deleted Data Re
     C                   MOVEL     P1DR05        GFDR05                         Deleted Data Re
     C                   MOVEL     P1DR06        GFDR06                         Deleted Data Re
     C                   MOVEL     P1DR07        GFDR07                         Deleted Data Re
     C                   MOVEL     P1DR08        GFDR08                         Deleted Data Re
     C                   MOVEL     P1DR09        GFDR09                         Deleted Data Re
     C                   MOVEL     P1DR00        GFDR00                         Deleted Data Re
     C                   MOVEL     P1DR11        GFDR11                         Deleted Data Re
     C                   MOVEL     P1DR12        GFDR12                         Deleted Data Re
     C                   Z-ADD     WURDNB        GFLCD                          Last Change Dat
     C                   MOVEL     P1TYLC        GFTYLC                         Type of Last Ch
      *
     C     KLCRSA        KLIST
     C                   KFLD                    GFFNME                         File name
      * Check for duplicate primary key
     C     KLCRSA        SETLL     @DELRL0                                90    *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'USR3550'     W0RTN             7
      * USER: Processing if Data record already exists
     C                   MOVEL     'Y2U0005'     W0RTN                          *Return code
      * Force a DB Update - SD Deleted Records File  *
     C                   WRITE     @DELRL0                              91
     C                   GOTO      SAEXIT
     C                   END
      *
     C                   WRITE     @DELRL0                              91      *
      *
     C     *IN91         IFEQ      '1'
      * Write error detected
     C                   MOVEL     'Y2U0004'     W0RTN             7
     C                   ELSE
     C                   END
      *================================================================
     CSR   SAEXIT        ENDSR
      /EJECT
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
      * Define work field Midas Run Date
     C                   MOVEL     *BLANK        WUMRDT            7
      * Define work field Run day number
     C                   Z-ADD     *ZERO         WURDNB            5 0
      * Define work field Set Up Complete
     C                   MOVEL     *BLANK        WUSUC             1
      * Define work field Date format flag
     C                   MOVEL     *BLANK        WUDFF             1
      * Define work field Multi-branching Indicator
     C                   MOVEL     *BLANK        WUMBIN            1
      * Move main file information to JOB context
     C                   MOVE      @1FFL         ZZFFL            10            Main file name
     C                   MOVE      @1FLB         ZZFLB            10            Main file lib
     C                   MOVE      @1FMB         ZZFMB            10            Main file mbr
     C                   MOVE      ZZFFL         @1FFL            10
     C                   MOVE      ZZFLB         @1FLB            10
     C                   MOVE      ZZFMB         @1FMB            10
     C                   CALL      'Y2QLVNR'
     C                   PARM                    ZZFFL            10
     C                   PARM                    ZZFLB            10
     C                   PARM                    ZZFQL            21            LIBRARY/FILE
      * Open files
     C                   OPEN      SDDELRL0
     C                   MOVEL     'N'           W0PMT             1
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SD0520XPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0520XPS1
      * The following /COPY contains the standard program status
      * subroutine
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SD0520XPS2
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2003
