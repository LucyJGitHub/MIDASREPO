     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas AP List of JE Valid Errors')
      *****************************************************************
      *                                                               *
      *  Midas - API Module                                           *
      *                                                               *
      *  AP0007 - List of JE Valid Errors                             *
      *                                                               *
      *  Function:  This program reports the Journal Entry Valid      *
      *             Errors from the Database Updater function.        *
      *                                                               *
      *  Called By: APC0007 - List of JE Valid Errors                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Prev Amend No. 186206   *CREATE   Date 26Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  186206 - Journal Entry API fixes. Produce only one dump      *
      *           per JE batch. Generate JE Valid errors report.      *
      *           Prevent record locking error in JE database         *
      *           updater.                                            *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FGLVEBITZL0IF   E           K DISK    INFSR(*PSSR)
      ** Valid JE Headers/Items
      *
     FAP0007AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
     FAP0007P1  O    E             PRINTER
     F                                     INFDS(SPOOL1) USROPN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Function of indicators                                       *
      *  ----------------------                                       *
      *                                                               *
      *   10 - File access indicator for GLVEBITZL0                   *
      *   11 - GLVBITHD0 record format                                *
      *   12 - GLVBITPD0 record format                                *
      *   60 - General file excess indicator                          *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      *  U7+U8 - Database error occurs                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      *
     D PSDS           SDS
      ** Program Status Data Structure
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
     D SPOOLU          DS
      ** File information data structure for Audit file
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SPOOL1          DS
      ** File information data structure for AP0007P1
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  SOFLN1               188    189B 0
     D  SPRLN1               367    368B 0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Data structure for access objects, first DS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure for Bank ICD
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** Data structure for SAR details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure for Currency details
      *
     IGLVBITHD0     11
      *
     IGLVBITPD0     12
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Initial processing
     C                   EXSR      SRInit
      *
      ** Main processing
     C                   EXSR      SRMain
      *
      ** Termination
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMain - Main Processing                                      *
      *                                                               *
      * Called by:                                                    *
      * Calls:     SRAudit, SRRCFP1, SRFormatHp1, SROutputHP1,        *
      *            SRFormatPP1, SROutputPP1, SRDummyHP1, SRTrailP1    *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
      *
      ** Read input file
      *
     C                   MOVEA     '00'          *IN(11)
     C                   READ      GLVEBITZL0                             10
      *
      ** If no records, output audit and bypass detail processing
      *
     C                   IF        (*IN10 = *ON)
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   OPEN      AP0007P1                             60
     C                   IF        *IN60 = *ON
     C                   MOVEL     'AP0007P1'    DBFILE
     C                   MOVEL     '*OPEN   '    DBKEY
     C                   Z-ADD     3             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   EXSR      SRRCFP1
      *
      ** Detail processing
      *
     C                   DOW       (*IN10 = *OFF)
      *
     C                   IF        *IN11 = *ON
     C                   MOVEL     B1FRNT        W1FRNT           20
     C                   ENDIF
      *
     C                   SELECT
      *
      ** JE Header record
     C                   WHEN      *IN11 = *ON
     C                   ADD       1             RCountH
     C                   EXSR      SRFormatHP1
     C                   EXSR      SROutputHP1
      *
      ** JE Item record and is under the previously read JE Header
     C                   WHEN      *IN12 = *ON
     C                             AND (B2FRNT = W1FRNT)
     C                   ADD       1             RCountP
     C                   EXSR      SRFormatPP1
     C                   EXSR      SROutputPP1
      *
      ** JE Item record and is Not under the previously read JE Header
     C                   WHEN      *IN12 = *ON
     C                             AND (B2FRNT <> W1FRNT)
     C                   ADD       1             RCountP
     C                   EXSR      SRDummyHP1
     C                   EXSR      SRFormatPP1
     C                   EXSR      SROutputPP1
     C                   MOVEL     B2FRNT        W1FRNT
      *
     C                   ENDSL
      *
     C                   MOVEA     '00'          *IN(11)
     C                   READ      GLVEBITZL0                             10
      *
     C                   ENDDO
      *
     C                   EXSR      SRTrailP1
     C                   EXSR      SRAudit
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDummyHP1 - Output dummy header for JE Items that don't have *
      *              HE Headers.                                      *
      *                                                               *
      * Called by: SRMain                                             *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SRDummyHP1    BEGSR
      *
      ** Check for overflow, 3 blank lines
      *
     C                   Z-ADD     3             WReqLin
     C     SOFLN1        SUB       SPRLN1        WDFLN
     C                   IF        WDFLN  <= WReqLin
     C                   WRITE     HeadP1
     C                   ENDIF
      *
     C                   WRITE     DtlZP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFormatHP1 - Format JE Header fields to be written to        *
      *               printer file 1.                                 *
      *                                                               *
      * Called by: SRMain                                             *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SRFormatHP1   BEGSR
      *
      ** Batch number
     C                   MOVEL     B1BTNB        RBTNB
      *
      ** Front Office ID
     C                   MOVEL     B1FRNT        RFRNT
      *
      ** Batch description
     C                   MOVEL     B1BDES        RBDES
      *
      ** Branch Code
     C                   MOVEL     B1BCDA        RBRCA
      *
      ** Department Code
     C                   MOVEL     B1DPCD        RDEPT
      *
      ** Multiple Branch Batch
     C                   MOVEL     B1MBRB        RMBRB
      *
      ** Workstation ID
     C                   MOVEL     B1WSID        RWSID
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROutputHP1 - Ouput formatted JE Header to printer file 1.    *
      *                                                               *
      * Called by: SRMain                                             *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SROutputHP1   BEGSR
      *
      ** Check for overflow
      *
     C                   Z-ADD     7             WReqLin
     C     SOFLN1        SUB       SPRLN1        WDFLN
     C                   IF        WDFLN  <= WReqLin
     C                   WRITE     HeadP1
     C                   ENDIF
      *
     C                   WRITE     DtlHP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFormatPP1 - Format JE Items fields to be written to         *
      *               printer file 1.                                 *
      *                                                               *
      * Called by: SRMain                                             *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SRFormatPP1   BEGSR
      *
      ** Batch Item number
      *
     C                   Z-ADD     B2BINB        RBINB
      *
      ** Batch number
      *
     C                   MOVEL     B2BTNB        RBTNB
      *
      ** Front Office ID
      *
     C                   MOVEL     B2FRNT        RFRNT
      *
      ** Account Identifier
      *
     C                   MOVE      *BLANKS       RACID
     C                   IF        B2RNBE = 'Y'
     C                   MOVEL     B2RACN        RACID
     C                   ELSE
     C                   MOVEL     B2CUST        RACID
     C                   ENDIF
      *
      ** Currency Code
      *
     C                   MOVEL     B2CYCD        RCYCD
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtnCde           7
     C                   PARM      '*KEY   '     POption           7
     C                   PARM      B2CYCD        PInChr03          3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        PRtnCde <> *BLANKS
     C                   Z-ADD     4             DBASE
     C                   MOVEL     B2CYCD        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Account Code
      *
     C                   MOVEL     B2ACCD        RACCD
      *
      ** Account Sequence number
      *
     C                   MOVEL     B2ACSN        RACSN
      *
      ** Input Branch Code
      *
     C                   MOVEL     B2IBCA        RIBCA
      *
      ** Posting Amount
      *
     C                   MOVEL     *BLANKS       RFMPA
     C                   Z-ADD     B2PTAM        PInAmt
      *
      ** Format Amount with IBM edit code
     C                   CALL      'GL0135U'
      ***********
      ** Input **
      ***********
      ** Input amount
     C                   PARM                    PInAmt           15 0
      ** Number of decimals
     C                   PARM      A6NBDP        PNumDec           1 0
      ** Edit code
     C                   PARM      '3'           PEdtCde           1
      ** Cheque protect
     C                   PARM      *BLANK        PChqPro           1
      ************
      ** Output **
      ************
      ** Formatted amount
     C                   PARM      *BLANKS       POutAmt          23
      *
     C                   MOVE      POutAmt       RFMPA
      *
      ** Debit/Credit indicator
      *
     C                   MOVEL     B2DCIN        RDCIN
      *
      ** Narrative
      *
     C                   MOVEL     *BLANKS       RNRTV
     C                   IF        B2NVCD <> *BLANKS
     C                   MOVEL     B2NVCD        RNRTV
     C                   ELSE
     C                   MOVEL     B2NRDC        RNRTV
     C                   ENDIF
      *
      ** Transaction Type
      *
     C                   MOVEL     B2TRTY        RTRTY
      *
      ** Transaction SubType
      *
     C                   MOVEL     B2TSTY        RTSTY
      *
      ** Value date
      *
     C                   MOVEL     *BLANKS       RVDDS
     C                   IF        B2VLDT <> *ZERO
     C                   CALL      'ZDATE2'
     C                   PARM      B2VLDT        PRunDay           5 0
     C                   PARM      BJDFIN        PDatFmt           1
     C                   PARM      *ZERO         POutDat6          6 0
     C                   PARM      *BLANKS       POutDat7          7
     C                   ENDIF
     C                   MOVE      POutDat6      RVDDS
      *
      ** Cheque number
      *
     C                   MOVEL     B2CQNB        RCQNB
      *
      ** SWIFT Common Reference
      *
     C                   MOVEL     B2SWCR        RSWCR
      *
      ** Profit Centre
      *
     C                   MOVEL     B2PRCN        RPRCN
      *
      ** Associated Customer Number
      *
     C                   MOVEL     B2ACNB        RACNB
      *
      ** Book Code
      *
     C                   MOVEL     B2BKCD        RBKCD
      *
      ** Reverse/Void indicator
      *
     C                   MOVEL     B2RVDI        RRVDI
      *
      ** Number of Items
      *
     C                   Z-ADD     B2NITM        RNITM
      *
      ** Retail indicator - Override
      *
     C                   MOVEL     B2RINO        RRINO
      *
      ** Original currency/amount
      *
     C                   MOVEL     *BLANKS       ROCCY
     C                   MOVEL     *BLANKS       RFMOA
      *
     C                   IF        CEU013 = 'Y'
     C                             AND (B2OCCY <> *BLANKS )
      *
     C                   MOVEL     B2OCCY        ROCCY
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      B2OCCY        PInChr03
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        PRtnCde <> *BLANKS
     C                   Z-ADD     5             DBASE
     C                   MOVEL     B2OCCY        DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     B2OAMT        PInAmt
      *
     C                   CALL      'GL0135U'
      ***********
      ** Input **
      ***********
      ** Input amount
     C                   PARM                    PInAmt
      ** Number of decimals
     C                   PARM      A6NBDP        PNumDec
      ** Edit code
     C                   PARM      '3'           PEdtCde
      ** Cheque protect
     C                   PARM      *BLANK        PChqPro
      ************
      ** Output **
      ************
      ** Formatted amount
     C                   PARM      *BLANKS       POutAmt
      *
     C                   MOVE      POutAmt       RFMOA
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SROutputPP1 - Ouput formatted JE Items to printer file 1.     *
      *                                                               *
      * Called by: SRMain                                             *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SROutputPP1   BEGSR
      *
      ** Check for overflow
      *
     C                   Z-ADD     8             WReqLin
     C     SOFLN1        SUB       SPRLN1        WDFLN
     C                   IF        WDFLN  <= WReqLin
     C                   WRITE     HeadP1
     C                   ENDIF
      *
     C                   WRITE     DtlPP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailP1- Output report trailer of printer file 1.           *
      *                                                               *
      * Called by: SRMain                                             *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SRTrailP1     BEGSR
      *
     C                   Z-ADD     4             WReqLin
     C     SOFLN1        SUB       SPRLN1        WDFLN
     C                   IF        WDFLN  <= WReqLin
     C                   WRITE     HeadP1
     C                   ENDIF
      *
     C                   WRITE     TrlP1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Ouput Audit report and terminate program.           *
      *                                                               *
      * Called by: SRMain, SRRCFAU, SRRCFP1, *PSSR                    *
      * Calls:     None.                                              *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
      *
      ** Report header and file control
      *
     C                   WRITE     HEADAU
     C                   WRITE     CTRLAU
      *
      ** Database error
      *
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERAU
     C                   ELSE
      ** No details
     C                   IF        (RCountH = 0)
     C                             AND (RCountP = 0)
     C                   WRITE     NODTAU
     C                   ENDIF
     C                   ENDIF
      *
      ** Terminate program
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFAU - RCF processing for the Audit printer file.          *
      *                                                               *
      * Called by: SRInit, SRAudit                                    *
      * Calls:     ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SRRCFAU       BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          ZSEQ              5
     C                   PARM      *BLANKS       ZENT              3
     C                   PARM      SFILEU        ZSNAM            10
     C                   PARM      SFNUMU        ZSNUM             6 0
     C                   PARM      *BLANK        ZERR              1
     C                   IF        ZERR = 'Y'
     C                   MOVEL     'ZSFILE  '    DBFILE
     C                   MOVEL     SFILEU        DBKEY
     C                   Z-ADD     6             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - RCF processing for printer file 1                   *
      *                                                               *
      * Called by: SRMain, SRAudit                                    *
      * Calls:     ZSFILE                                             *
      *                                                               *
      *****************************************************************
     C     SRRCFP1       BEGSR
      *
     C                   CALL      'ZSFILE'
     C                   PARM      PSeq          ZSEQ              5
     C                   PARM      *BLANKS       ZENT              3
     C                   PARM      SFILE1        ZSNAM            10
     C                   PARM      SFNUM1        ZSNUM             6 0
     C                   PARM      *BLANK        ZERR              1
     C                   IF        ZERR = 'Y'
     C                   MOVEL     'ZSFILE  '    DBFILE
     C                   MOVEL     SFILE1        DBKEY
     C                   Z-ADD     7             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      SRAudit
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialisation routine                               *
      *                                                               *
      * Called by: MAIN                                               *
      * Calls:     *PSSR, SRRCFAU                                     *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSeq              5
     C                   PARM                    PLvl              1
     C                   PARM                    PEnt              3
      *
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
     C     *DTAARA       DEFINE                  LDA
      *
     C                   MOVEL     'AP0007'      DBPGM
      *
      ** Access bank ICD
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WRTCD             7
     C                   PARM      '*FIRST  '    WOPTN             7
     C     SDBANK        PARM      *BLANKS       DSFDY
     C                   IF        WRTCD <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** Set up data format indicator
     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *IN98
     C                   ENDIF
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CEU013'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRtnCde       IFNE      *BLANKS
     C     PRtnCde       ANDNE     '*NRF   '
     C                   MOVEL     'CEU013'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRtnCde       IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   ENDIF
      *
      ** RCF processing
     C                   EXSR      SRRCFAU
      *
     C                   Z-ADD     0             RCountH
     C                   Z-ADD     0             RCountP
     C                   Z-ADD     0             WReqLin           3 0
     C                   Z-ADD     0             WDfLn             3 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine.                           *
      *                                                               *
      * Called by: Error trapping routine                             *
      * Calls:     *PSSR, SRAudit                                     *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRun <> 'Y'
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
** CPY@ - Object copyright
(c) Misys International Banking Systems Ltd. 2001
