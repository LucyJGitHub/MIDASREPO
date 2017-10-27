     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Transactions Initialisation program')         *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  RPGLE/DL000015 - Dealing Transactions Initialisation program *
      *                                                               *
      *  Called from: Command Entry line                              *
      *               One-time set-up program.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSW212             Date 03May12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAS009             Date 16May05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 228018             Date 25Jun04               *
      *                 CAS008             Date 16Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  228018 - Update fields FSOFYC and FSTFYC as well.            *
      *           Also use correct deal type field of HKMTYP instead  *
      *           of the front office field HKTYPE for MMDELDPP.      *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in FXDEALPP.*
      *           , MMDELDPP, MMDENBPP AND MMDENSPP.                  *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  60 - End of File                                             *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SRDfltBOF  - Initialise fields in Back Office Files (DEALSDB,*
      *               DEALSDC, DEALSDD)                               *
      *  SRDfltFOFX - Initialise fields in Front Office File; FXDEALPP*
      *  SRDfltFOLD - Initialise fields in Front Office File; MMDELDPP*
      *  SRDfltFONP - Initialise fields in Front Office File; MMDENBPP*
      *  SRChFile   - Access Deal Type/subtype File                   *
      *  SRAudit    - Write Audit Report                              *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
     FDEALS     UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     COMMIT
      ** Back Office Deals (FX, L/D, NA Purchased, FRA/IRS)
 
     FFXDEALLL  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Front Office Foreign Exchange Deals
 
     FMMDEALLL  UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(MMDENSP0)
     F                                     COMMIT
      ** Front Office Loans and Deposits, Negotiable Assets Purchased
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Deal Types/Subtypes Retrieval Index
 
     FDL000015AUO    E             PRINTER
      ** Audit file
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D/COPY WNCPYSRC,DLH00316
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
     D PSDS           SDS
 
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
 
      ** Process Back Office deals (DEALSDB, DEALSDC, DEALSDD, DEALSDG)
 
     C     *LOVAL        SETLL     DEALS
     C                   DOU       *IN60 = *ON
     C                   READ      DEALS                                  60
 
     C                   IF        *IN60 = *OFF and RECI = 'D'
 
     C/COPY WNCPYSRC,DLH00317
      ** If a live FX/MM/NAP/IRS deal is found
 
     C                   ADD       1             COUNTF
 
      ** Call subroutine that defaults values for yield curve fields
 
     C                   EXSR      SRDfltBOF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C/COPY WNCPYSRC,DLH00318
      ** Process Foreign Exchange records
 
     C     *LOVAL        SETLL     FXDEALLL
     C                   DOU       *IN60 = *ON
     C                   READ      FXDEALLL                               60
 
     C                   IF        *IN60 = *OFF and FHDDLT = *blanks
     C                             and FHDSTS <> 'E' and FHDSTS <> 'M'
 
      ** If a live Foreign Exchange deal record is found
 
     C                   ADD       1             COUNTF
 
      ** Call subroutine that defaults values for yield curve fields
 
     C                   EXSR      SRDfltFOFX
      *
     C                   ENDIF
      *
     C                   ENDDO
 
     C/COPY WNCPYSRC,DLH00319
      ** Process Loan and Deposit records
 
     C     *LOVAL        SETLL     MMDELDP0
     C                   DOU       *IN60 = *ON
     C                   READ      MMDELDP0                               60
 
     C                   IF        *IN60 = *OFF and HKDDLT = *blanks
     C                             and HKDSTS <> 'M'
 
      ** If a live record is found
 
     C                   ADD       1             COUNTF
 
      ** Call subroutine that defaults values for yield curve fields
 
     C                   EXSR      SRDfltFOLD
 
     C                   ENDIF
     C                   ENDDO
 
      ** Process Negotiable Asset Purchased records
 
     C     *LOVAL        SETLL     MMDENBP0
     C                   DOU       *IN60 = *ON
     C                   READ      MMDENBP0                               60
 
     C                   IF        *IN60 = *OFF and HLDDLT = *blanks
     C                             and HLDSTS <> 'M'
 
      ** If a live record is found
 
     C                   ADD       1             COUNTF
 
      ** Call subroutine that defaults values for yield curve fields
 
     C                   EXSR      SRDfltFONP
      *
     C                   ENDIF
     C                   ENDDO
 
     C/COPY WNCPYSRC,DLH00320
     C                   COMMIT
      *
     C                   EVAL      *INLR = *ON
 
      ** Write File Controls Report.
 
     C                   EXSR      SRAudit
 
      ** Subroutines
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltBOF - Initialise fields in Back Office Files (DEALSDB,  *
      *             DEALSDC, DEALSDD, DEALSDG)                        *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SR/SRChFile                                            *
      *                                                               *
      *****************************************************************
     C     SRDfltBOF     BEGSR
 
      ** Call subroutine to access file for default values of yield curve fields
 
     C                   EXSR      SRChFile
 
     C                   IF        %EOF = *OFF
 
      ** If found, default our yield curve field (common in the 4 deal files)
 
     C                   EVAL      FSOYLC = FSOURY
 
      ** If record type is 'B', default their yield curve field as well (only in DEALSDB)
 
     C                   IF        RCDT = 'B'
     C                   EVAL      FSTYLC = FSTHRY
     C                   ENDIF
 
      ** If record type is 'G' and deal type is 'RX' or 'RS',
      ** default Their Yield Curve field as well (only in DEALSDG)
 
     C                   IF        RCDT = 'G'
 
     C                   IF        DTYP = 'RX' OR
     C                             DTYP = 'RS'
     C                   EVAL      FSTYLC = FSTHRY
     C                   EVAL      FSOFYC = FSORFY                                            228018
     C                   EVAL      FSTFYC = FSTHFY                                            228018
     C                   ELSE
     C                   EVAL      FSOYLC = *blanks
     C                   EVAL      FSTYLC = *blanks
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      FSOYLC = *blanks
     C                   EVAL      FSTYLC = *blanks
     C                   ENDIF
 
     C                   IF        RCDT = 'B'
     C                   UPDATE    DEALSDBF
 
     C                   IF        FSOYLC <> *blanks OR
     C                             FSTYLC <> *blanks
     C                   ADD       1             COUNTDB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        RCDT = 'C'
     C                   UPDATE    DEALSDCF
     C                   IF        FSOYLC <> *blanks
     C                   ADD       1             COUNTDC
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RCDT = 'D'
     C                   UPDATE    DEALSDDF
     C                   IF        FSOYLC <> *blanks
     C                   ADD       1             COUNTDD
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RCDT = 'G'
     C                   UPDATE    DEALSDGF
     C                   IF        FSOYLC <> *blanks OR
     C                             FSTYLC <> *blanks
     C                   ADD       1             COUNTDG
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltFOFX - Initialise fields in Front Office File (FXDEALPP)*
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDfltFOFX    BEGSR
 
      ** Access the Deal Type/Subtype file for default values for the
      ** Buy/Our Yield Curve and Sell/Their Yield Curve
 
     C                   EVAL      WkDTYP = FHTYPE
     C                   EVAL      WkDLST = FHSTYP
     C                   EVAL      WkCLAS = FHCLAS                                            CDL038
 
     C     KyDeal        CHAIN     FDDTSTL1                           01
 
     C                   IF        *IN01 = *OFF
 
      ** If found, default our/their yield curve fields
 
     C                   EVAL      FHOYLC = FSOURY
     C                   EVAL      FHTYLC = FSTHRY
 
     C                   ELSE
     C                   EVAL      FHOYLC = *blanks
     C                   EVAL      FHTYLC = *blanks
     C                   ENDIF
 
     C                   UPDATE    FXDEALP0
 
     C                   IF        FHOYLC <> *blanks OR
     C                             FHTYLC <> *blanks
     C                   ADD       1             COUNTFX
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltFOLD - Initialise fields in Front Office File (MMDELDPP)*
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDfltFOLD    BEGSR
 
      ** Access the Deal Type/Subtype file for default values for the
      ** Buy/Our Yield Curve and Sell/Their Yield Curve
 
     C**********         EVAL      WkDTYP = HKTYPE                                            228018
     C                   EVAL      WkDTYP = HKMTYP                                            228018
     C                   EVAL      WkDLST = HKSTYP
     C                   EVAL      WkCLAS = HKCLAS                                            CDL038
 
     C     KyDeal        CHAIN     FDDTSTL1                           01
 
     C                   IF        *IN01 = *OFF
 
      ** If found, default our yield curve field
 
     C                   EVAL      HKOYLC = FSOURY
 
     C                   ELSE
     C                   EVAL      HKOYLC = *blanks
     C                   ENDIF
 
     C                   UPDATE    MMDELDP0
     C                   IF        HKOYLC <> *blanks
     C                   ADD       1             COUNTLD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDfltFONP - Initialise fields in Front Office File (MMDENBPP)*
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRDfltFONP    BEGSR
 
      ** Access the Deal Type/Subtype file for default values for the
      ** Buy/Our Yield Curve
 
     C                   EVAL      WkDTYP = HLTYPE
     C                   EVAL      WkDLST = HLSTYP
     C                   EVAL      WkCLAS = HLCLAS                                            CDL038
 
     C     KyDeal        CHAIN     FDDTSTL1                           01
 
     C                   IF        *IN01 = *OFF
 
      ** If found, default our yield curve field
 
     C                   EVAL      HLOYLC = FSOURY
 
     C                   ELSE
     C                   EVAL      HLOYLC = *blanks
     C                   ENDIF
 
     C                   UPDATE    MMDENBP0
     C                   IF        HLOYLC <> *blanks
     C                   ADD       1             COUNTNP
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChFile - Subroutine to Access Deal Type/subtype File        *
      *                                                               *
      * Called by: SR/SRDfltBOF                                       *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChFile      BEGSR
 
      ** Access the Deal Type/Subtype file for default values for the
      ** Buy/Our Yield Curve and Sell/Their Yield Curve
 
     C                   EVAL      WkDTYP = DTYP
     C                   EVAL      WkDLST = DLST
     C                   EVAL      WkCLAS = CLAS                                              CDL038
 
     C     KyDeal        CHAIN     FDDTSTL1                           01
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAudit - Subroutine to Write Audit Report                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
 B1  C                   IF        COUNTF <> 0
     C                   WRITE     CONTROL
 
     C                   ELSE
     C                   WRITE     NODTLS
 E1  C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *                                                               *
      * Called by: Automatically called upon entry to the module      *
      *                                                               *
      * Calls: SR/*PSSR                                               *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     CPY@          BIS@             80
 
      **  Set up Local Data Area (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVE      *BLANKS       DBPGM
     C                   MOVEL     'DL000015'    DBPGM
     C                   Z-ADD     0             DBASE
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY WNCPYSRC,DLH00321
      ** Initialise counters
 
     C                   Z-ADD     *ZERO         COUNTF            9 0
     C                   Z-ADD     *ZERO         COUNTDB           9 0
     C                   Z-ADD     *ZERO         COUNTDC           9 0
     C                   Z-ADD     *ZERO         COUNTDD           9 0
     C                   Z-ADD     *ZERO         COUNTDG           9 0
     C                   Z-ADD     *ZERO         COUNTFX           9 0
     C                   Z-ADD     *ZERO         COUNTLD           9 0
     C                   Z-ADD     *ZERO         COUNTNP           9 0
 
 
      ** Initialize constant fields
 
     C                   Z-ADD     *ZEROS        FSURPL
     C                   Z-ADD     *ZEROS        FSTUPL
     C                   Z-ADD     *ZEROS        FSPUPL
     C                   Z-ADD     *ZEROS        FSYUPL
 
      ** Key List for Deal types/subtypes file
 
     C     KyDeal        KLIST
     C                   KFLD                    WkDTYP            2
     C                   KFLD                    WkDLST            2
     C                   KFLD                    WkCLAS            4                          CDL038
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   MOVE      'Y'           WDUMP             1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
 
      ** Write File Control Report Heading
 
     C                   WRITE     HEADAU
 
      ** Write Database error
 
     C                   WRITE     DBERROR
 
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
