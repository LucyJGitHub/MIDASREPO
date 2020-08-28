     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Retail Account Margin History Update')        *
      *****************************************************************
      *                                                               *
      *  Midas - Retail module                                        *
      *                                                               *
      *  RE3669   - Retail Account Margin History Update.             *
      *                                                               *
      *  Function:  This module processes all records from the Retail *
      *             ICD by currency file and for any which have had   *
      *             debit or credit margin rate changes, the new      *
      *             rates will be used to create margin history for   *
      *             accounts using the defaults. The accounts not     *
      *             using the defaults will also be checked and any   *
      *             that have had direct debit or credit margin       *
      *             changes will be processed to create margin history*
      *             as well.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 17Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  208221 - Default Margin from Rate/Spread changes             *
      *  CDE002 - Retail Account Margin History Update.               *
      *                                                               *
      *****************************************************************
 
     FRECCY     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(RECCYDF)
 
     FGLACBXL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
     FGLACBXL1  IF   E           K DISK    RENAME(ACCNTBD0: ACCNTBD1)
     F                                     INFSR(*PSSR)
     FGLACBXL2  IF   E           K DISK    RENAME(ACCNTBD0: ACCNTBD2)
     F                                     INFSR(*PSSR)
     FGLACBXL3  IF   E           K DISK    RENAME(ACCNTBD0: ACCNTBD3)
     F                                     INFSR(*PSSR)
 
     FREHMRGPD  O    E             DISK
     F                                     PREFIX(O_)
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
     D RECCYREC      E DS                  EXTNAME(RECCYD)
     D  ZZZ053       E                     EXTFLD(ZZ053)
     D  Currency              10     12
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
 
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  208221
      ** EXTERNAL DS FOR CURRENCY DETAILS                                                     208221
                                                                                              208221
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     208221
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                                   208221
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      *
     C                   EXSR      MAIN
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C/SPACE 5
      *****************************************************************
      * MAIN - Main Processing                                        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MAIN          BEGSR
      *
     C                   READ      RECCY                                  99    *
      *
      ** Whilst records can be found....
      *
     C     *IN99         DOWEQ     '0'
      *
     C     Currency      SETLL     GLACBXL0
     C     Currency      READE     GLACBXL0                               90
      *
      **  Process all records for currency on GLACBXL0 which have
      **  Debit Margin Change Date equal to today's run date.
     C     *IN90         DOWEQ     '0'
      *
     C     DRMD          IFEQ      BJRDNB
     C     ATDRMD        OREQ      BJRDNB
      *
      **  Set up fields on REHMRGPD...
     C                   EVAL      O_BRCA = ATBRCA
     C                   EVAL      O_CNUM = ATCNUM
     C                   EVAL      O_CCY  = ATCCY
     C                   EVAL      O_ACOD = ATACOD
     C                   EVAL      O_ACSQ = ATACSQ
     C                   EVAL      O_ACNO = ATACNO
     C                   EVAL      O_HISD = BJRDNB
     C                   EVAL      O_MGDRCR = '0'
     C                   EVAL      O_MGRATE = DRMG
      *
     C                   WRITE     REHMRGD0
     C                   ENDIF
      *
     C     Currency      READE     GLACBXL0                               90
     C                   ENDDO
      *
      *
     C     Currency      SETLL     GLACBXL1
     C     Currency      READE     GLACBXL1                               91
      *
      **  Process all records for currency on GLACBXL1 which have
      **  Credit Margin Change Date equal to today's run date.
     C     *IN91         DOWEQ     '0'
      *
     C     CRMD          IFEQ      BJRDNB
     C     ATCRMD        OREQ      BJRDNB
      *
      **  Set up fields on REHMRGPD...
     C                   EVAL      O_BRCA = ATBRCA
     C                   EVAL      O_CNUM = ATCNUM
     C                   EVAL      O_CCY  = ATCCY
     C                   EVAL      O_ACOD = ATACOD
     C                   EVAL      O_ACSQ = ATACSQ
     C                   EVAL      O_ACNO = ATACNO
     C                   EVAL      O_HISD = BJRDNB
     C                   EVAL      O_MGDRCR = '1'
     C                   EVAL      O_MGRATE = CRMG
      *
     C                   WRITE     REHMRGD0
     C                   ENDIF
      *
     C     Currency      READE     GLACBXL1                               91
     C                   ENDDO
      *
      ** Read the next currency record.
      *
     C                   READ      RECCY                                  99    *
     C                   ENDDO
      *
      *
      ** Process all records on GLACBXL2 which have debit margin rate
      ** change date equal to today's run date.
      *
     C                   READ      GLACBXL2                               92
      *
     C     *IN92         DOWEQ     '0'
      *
     C     ATDRMD        IFEQ      BJRDNB
 
      **  Set up fields on REHMRGPD...
     C                   EVAL      O_BRCA = ATBRCA
     C                   EVAL      O_CNUM = ATCNUM
     C                   EVAL      O_CCY  = ATCCY
     C                   EVAL      O_ACOD = ATACOD
     C                   EVAL      O_ACSQ = ATACSQ
     C                   EVAL      O_ACNO = ATACNO
     C                   EVAL      O_HISD = BJRDNB
     C                   EVAL      O_MGDRCR = '0'
     C                   EVAL      O_MGRATE = ATDRMG
      *                                                                                       208221
     C     ATDRMG        IFEQ      0                                                          208221
     C     ATDMBR        ANDNE     *BLANKS                                                    208221
     C                   MOVEL     ATDMBR        @CYCD                                        208221
     C                   MOVE      ATDMBR        @BSRC                                        208221
     C                   CALLB     'AOBSRTR0'                                                 208221
     C                   PARM      *BLANKS       @RTCD                                        208221
     C                   PARM      '*KEY   '     @OPTN                                        208221
     C                   PARM                    @CYCD             3                          208221
     C                   PARM                    @BSRC             2                          208221
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        208221
     C*                                                                                       208221
     C     @RTCD         IFEQ      *BLANKS                                                    208221
     C     BAVDNR        IFLE      BJRDNB                                                     208221
     C                   EVAL      O_MGRATE = BANBRT                                          208221
     C                   ELSE                                                                 208221
     C                   EVAL      O_MGRATE = BACBSR                                          208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *
     C                   WRITE     REHMRGD0
      *                                                                                       208221
      ** If a base rate was set up as the margin, need to check if the rate                   208221
      ** has changed                                                                          208221
      *                                                                                       208221
     C                   ELSE                                                                 208221
     C     ATDRMG        IFEQ      0                                                          208221
     C     ATDMBR        ANDNE     *BLANKS                                                    208221
     C                   MOVEL     ATDMBR        @CYCD                                        208221
     C                   MOVE      ATDMBR        @BSRC                                        208221
     C                   CALLB     'AOBSRTR0'                                                 208221
     C                   PARM      *BLANKS       @RTCD                                        208221
     C                   PARM      '*KEY   '     @OPTN                                        208221
     C                   PARM                    @CYCD             3                          208221
     C                   PARM                    @BSRC             2                          208221
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        208221
     C*                                                                                       208221
     C     @RTCD         IFEQ      *BLANKS                                                    208221
     C     BALCD         ANDEQ     BJRDNB                                                     208221
     C                   EVAL      O_BRCA = ATBRCA                                            208221
     C                   EVAL      O_CNUM = ATCNUM                                            208221
     C                   EVAL      O_CCY  = ATCCY                                             208221
     C                   EVAL      O_ACOD = ATACOD                                            208221
     C                   EVAL      O_ACSQ = ATACSQ                                            208221
     C                   EVAL      O_ACNO = ATACNO                                            208221
     C                   EVAL      O_HISD = BAVDNR                                            208221
     C                   EVAL      O_MGDRCR = '0'                                             208221
     C                   EVAL      O_MGRATE = BANBRT                                          208221
     C                   WRITE     REHMRGD0                                                   208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *                                                                                       208221
     C                   ENDIF
      *
     C                   READ      GLACBXL2                               92
     C                   ENDDO
      *
      *
      ** Process all records on GLACBXL3 which have credit margin rate
      ** change date equal to today's run date.
      *
     C                   READ      GLACBXL3                               93
      *
     C     *IN93         DOWEQ     '0'
      *
     C     ATCRMD        IFEQ      BJRDNB
 
      **  Set up fields on REHMRGPD...
     C                   EVAL      O_BRCA = ATBRCA
     C                   EVAL      O_CNUM = ATCNUM
     C                   EVAL      O_CCY  = ATCCY
     C                   EVAL      O_ACOD = ATACOD
     C                   EVAL      O_ACSQ = ATACSQ
     C                   EVAL      O_ACNO = ATACNO
     C                   EVAL      O_HISD = BJRDNB
     C                   EVAL      O_MGDRCR = '1'
     C                   EVAL      O_MGRATE = ATCRMG
      *                                                                                       208221
     C     ATCRMG        IFEQ      0                                                          208221
     C     ATCMBR        ANDNE     *BLANKS                                                    208221
     C                   MOVEL     ATCMBR        @CYCD                                        208221
     C                   MOVE      ATCMBR        @BSRC                                        208221
     C                   CALLB     'AOBSRTR0'                                                 208221
     C                   PARM      *BLANKS       @RTCD                                        208221
     C                   PARM      '*KEY   '     @OPTN                                        208221
     C                   PARM                    @CYCD             3                          208221
     C                   PARM                    @BSRC             2                          208221
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        208221
     C*                                                                                       208221
     C     @RTCD         IFEQ      *BLANKS                                                    208221
     C     BAVDNR        IFLE      BJRDNB                                                     208221
     C                   EVAL      O_MGRATE = BANBRT                                          208221
     C                   ELSE                                                                 208221
     C                   EVAL      O_MGRATE = BACBSR                                          208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *
     C                   WRITE     REHMRGD0
      *                                                                                       208221
      ** If a base rate was set up as the margin, need to check if the rate                   208221
      ** has changed                                                                          208221
      *                                                                                       208221
     C                   ELSE                                                                 208221
     C     ATCRMG        IFEQ      0                                                          208221
     C     ATCMBR        ANDNE     *BLANKS                                                    208221
     C                   MOVEL     ATCMBR        @CYCD                                        208221
     C                   MOVE      ATCMBR        @BSRC                                        208221
     C                   CALLB     'AOBSRTR0'                                                 208221
     C                   PARM      *BLANKS       @RTCD                                        208221
     C                   PARM      '*KEY   '     @OPTN                                        208221
     C                   PARM                    @CYCD             3                          208221
     C                   PARM                    @BSRC             2                          208221
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        208221
     C*                                                                                       208221
     C     @RTCD         IFEQ      *BLANKS                                                    208221
     C     BALCD         ANDEQ     BJRDNB                                                     208221
     C                   EVAL      O_BRCA = ATBRCA                                            208221
     C                   EVAL      O_CNUM = ATCNUM                                            208221
     C                   EVAL      O_CCY  = ATCCY                                             208221
     C                   EVAL      O_ACOD = ATACOD                                            208221
     C                   EVAL      O_ACSQ = ATACSQ                                            208221
     C                   EVAL      O_ACNO = ATACNO                                            208221
     C                   EVAL      O_HISD = BAVDNR                                            208221
     C                   EVAL      O_MGDRCR = '1'                                             208221
     C                   EVAL      O_MGRATE = BANBRT                                          208221
     C                   WRITE     REHMRGD0                                                   208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
      *                                                                                       208221
     C                   ENDIF
      *
     C                   READ      GLACBXL3                               93
     C                   ENDDO
      *
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Initialise Margin History Record ID
     C                   EVAL      O_RECI = 'G'
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
