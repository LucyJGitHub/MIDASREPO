     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Payment Date Offset Code Report')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer module                                *
      *                                                               *
      *  FT000576 - Payment Date Offset Code Report                   *
      *                                                               *
      *  Function:  This module displays the details of each payment  *
      *             date offset code                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BUG433             Date 02Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prve Amend No. CFT009  *CREATE    Date 05Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG433 - Recompiled due to change in FTPDOCPD                *
      *  CFT009 - FT Fees and Charges                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Printer Overflow                                *
      *    02         Read on FTPDOCL0                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * FILE2PRINT  - Moving file fields to print fields              *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFTPDOCL0  IF   E           K DISK
     FFT000576P1O    E             PRINTER OFLIND(*IN01) INFDS(SPOOL1)
     FFT000576AUO    E             PRINTER OFLIND(*IN02) INFDS(SPOOL2)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for access programs, short DS
      *
     D SPOOL1          DS
     D  Sfile1                83     92
     D  Sfnum1               123    124B 0
 
     D SPOOL2          DS
     D  Sfile2                83     92
     D  Sfnum2               123    124B 0
 
     ** Data for ZSFILE
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D RepDtl          S              1
 
     D ReturnCode      S              7
     D Option          S              7
 
     ** Parameters for AOBANKR0
 
     D RSeq            S              5
     D Rent            S              3
     D Sfilp           S             10
     D Splno           S              6  0
     D Zerr            S              1    INZ(*Blank)
 
     ** Parameters for ZSFILE
 
     D RETCODEIN       S             10
      *****************************************************************
 
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C     *Loval        Setll     FTPDOCL0
     C                   Read      FTPDOCL0                               02
 
      ** Write header
 
     C                   Write     HEADPY
 
     C                   Eval      RepDtl = 'Y'
 
     C                   Dow       *In02 = *Off
 
      ** Move file fields into print fields
 
     C                   Exsr      File2Print
 
      ** Write details
 
     C                   Write     DETAIL
 
      ** If overflow, write header
 
     C                   If        *In01 = *On
     C                   Write     HEADPY
     C                   Eval      *In01 = *Off
     C                   Endif
 
     C                   Read      FTPDOCL0                               02
     C                   Enddo
 
      ** Write trailer - 'End of report'
 
     C                   If        RepDtl <> 'Y'
     C                   Write     HEADPY
     C                   Write     NoDetl
     C                   Endif
 
     C                   Write     TRAILPY
 
     C                   Seton                                        LR
      /EJECT
      *****************************************************************
      *                                                               *
      * FILE2PRINT - Moving file fields to print fields               *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     File2Print    Begsr
 
     C                   EVAL      PLSTTM = *Blanks
     C                   EVAL      PLCOTM = *Blanks
 
     C                   Eval      POFCDE = PYDTOC
     C                   Eval      PDESCP = PYDTOD
 
     C                   MOVEL     LSTTIM        PLSTTM
     C                   CallB     'FTTIMECHAR'
     C                   Parm                    RetCodeIn
     C                   Parm                    PLSTTM
 
     C                   MOVEL     LCUTOF        PLCOTM
     C                   CallB     'FTTIMECHAR'
     C                   Parm                    RetCodeIn
     C                   Parm                    PLCOTM
 
     C                   Eval      PBCOSO = BCOSDO
     C                   Eval      PBCOPO = BCOPDO
     C                   Eval      PACOSO = ACOSDO
     C                   Eval      PACOPO = ACOPDO
 
     C                   Endsr
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
 
     C     *INZSR        Begsr
 
     C     *Entry        Plist
     C                   Parm                    PARM1             1
     C                   Parm                    RSEQ              5
     C                   Parm                    RLEV              1
     C                   Parm                    RENT              3
 
      ** RCF : List
 
     C                   Eval      Splno = Sfnum1
     C                   Eval      Sfilp = Sfile1
 
     C                   Call      'ZSFILE'
     C                   Parm                    Rseq
     C                   Parm                    Rent
     C                   Parm                    Sfilp
     C                   Parm                    Splno
     C                   Parm                    Zerr
 
      ** Database error
 
     C                   If        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      *INU7= *ON
     C                   Eval      *INU8= *ON
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  SFILE1
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  001
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
 
      ** RCF : Audit
 
     C                   Eval      Splno = Sfnum2
     C                   Eval      Sfilp = Sfile2
 
     C                   Call      'ZSFILE'
     C                   Parm                    Rseq
     C                   Parm                    Rent
     C                   Parm                    Sfilp
     C                   Parm                    Splno
     C                   Parm                    Zerr
 
      ** Database error
 
     C                   If        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      *INU7= *ON
     C                   Eval      *INU8= *ON
     C                   Eval      DBFILE =  'ZSFILE'
     C                   Eval      DBKEY  =  SFILE1
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  002
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
      ** Retrieve bank details
 
     C                   CallB     'AOBANKR0'
     C                   Parm      *Blanks       ReturnCode
     C                   Parm      '*FIRST   '   Option
     C     SDBANK        Parm      SDBANK        DSFDY
 
      ** Database error
 
     C                   If        ReturnCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   Eval      *INU7 = *ON
     C                   Eval      *INU8 = *ON
     C                   Eval      DBFILE =  'SDBANKPD'
     C                   Eval      DBKEY  =  '*FIRST'
     C                   Eval      DBPGM  =  PSProcPgm
     C                   Eval      DBASE  =  003
     C                   Eval      DBMOD  =  PSProcMod
     C                   Eval      DBPROC =  '*INZSR'
     C                   OUT       LDA
     C                   Write     DBERROR
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Endsr
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         Begsr
 
     C                   Dump
 
     C                   If        @RUN = *Blank
     C                   Eval      @RUN = 'Y'
 
     C                   CallB     'DBERRCTL'
 
     C                   Endif
 
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   Eval      *InLR = *On
     C                   Return
 
     C                   Endsr
 
      ********************************************************************
