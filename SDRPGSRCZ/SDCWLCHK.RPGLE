     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
     H THREAD(*SERIALIZE)
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Send watch list details from ILE programs')
/*OVRF*: OVRDBF FILE(SDCWDFL1) SHARE(*NO)                           : *                       CSD083
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCWLCHK - Send Watch List Details from ILE Programs         *
      *                                                               *
      *  Function:  This module will be made available to ILE progs   *
      *             to send the Watch list details to the Compliance  *
      *             Watch Engine Data Queue.                          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD015   *CREATE   Date 03Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
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
      **
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Input parameter containing transaction details
     D PITranDtls    E DS                  EXTNAME(SDWLTDPD)
     D                                     PREFIX(I)
 
      ** Input parameter for SDCWLCHK containing transaction details
     D POTranDtls    E DS                  EXTNAME(SDWLTDPD)
     D                                     PREFIX(O)
 
      ** DS for Check transaction data file                                                   CSD083
     D PONwTranDtl   E DS                  EXTNAME(SDCWDFPD)                                  CSD083
                                                                                              CSD083
      ** First DS for Access Programs, Short Data Structure                                   CSD083
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD083
                                                                                              CSD083
      ** Data Structure for SAR Details                                                       CSD083
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD083
                                                                                              CSD083
      ** DS for Midas Watch List Details Queue
     D SDWLSTDS      E DS                  EXTNAME(SDWLSTPD)
 
      ** DS for Midas Watch List Message Details Queue
     D SDWLMEDS      E DS                  EXTNAME(SDWLMEPD)
 
      ** Data structure for Currency details
     DSDCURR         E DS                  EXTNAME(SDCURRPD)
 
      ** Midas Compliance Watch List Feeder Running Data Area
     D SDRWENGN      E DS                  EXTNAME(SDRWENGN) DTAARA(SDRWENGN)
 
      ** Short Data structure
     DDSSDY          E DS                  EXTNAME(DSSDY)
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PSrchStrng      S          30000
 
      ** Parameter for AOCURRR0
     D PmRetn          S              7
     D PmOption        S              7
     D PmCcy           S              3
 
      ** Parameter for AOBANKR0                                                               CSD083
     D PRTCD           S              7A                                                      CSD083
     D POPTN           S              7A                                                      CSD083
     D PSARD           S              6A                                                      CSD083
     D CSD083          S              1A                                                      CSD083
                                                                                              CSD083
     D TempAmt         S             18S 3
     D PDtqNam         S             10A
     D PDtqLib         S             10A
     D PDtqLen         S              5  0
     D PDtqWait        S              5  0
     D PDtqMsg         S          31000A
 
     D @RUN            S              1
 
      *****************************************************************
      /EJECT
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
 
      ** Check  Search string details if blanks
 
     C                   IF        PSrchStrng = *BLANKS and IW4FUNT <> 'MGOREF'
     C                   GOTO      ExitPgm
     C                   ENDIF
 
      ** Move input transaction details to output transaction details
 
     C                   EVAL      OW4IDEN = IW4IDEN
     C                   EVAL      OW4ITEM = IW4ITEM
     C                   EVAL      OW4BRCH = IW4BRCH
     C                   EVAL      OW4SYSM = IW4SYSM
     C                   EVAL      OW4FUNT = IW4FUNT
     C                   EVAL      OW4CNUM = IW4CNUM
     C                   EVAL      OW4CTYP = IW4CTYP
     C                   EVAL      OW4CUST = IW4CUST
     C                   EVAL      OW4DDAT = IW4DDAT
     C                   EVAL      OW4VDAT = IW4VDAT
     C                   EVAL      OW4MDAT = IW4MDAT
     C                   EVAL      OW4DEN1 = IW4DEN1
     C                   EVAL      OW4DEN2 = IW4DEN2
     C                   EVAL      OW4ARLS = IW4ARLS
     C                   Z-ADD     IW4AMT1       OW4AMT1
     C                   Z-ADD     IW4AMT2       OW4AMT2
 
      ** Write a record to the Midas Watch List Message Details Queue File
 
     C                   IF        OW4FUNT = 'MGOREF'
 
     C                   EVAL      W7IDEN = OW4IDEN
     C                   EVAL      W7ITEM = OW4ITEM
     C                   EVAL      W7BRCH = OW4BRCH
     C                   EVAL      W7CNUM = OW4CNUM
     C                   MOVE      OW4DDAT       W7DDAT
     C                   EVAL      W7ARLS = OW4ARLS
     C                   EVAL      W7SSTR = PSrchStrng
 
      ** Write record to Message Detail Dataq
 
     C                   MOVEL     SDWLMEDS      PDtqMsg
     C                   EVAL      PDtqLen = 31000
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SDCWMDTQ'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqMsg
 
     C                   ELSE
 
      ** Write a record to the Midas Watch List Details Dataq Queue
 
     C                   EVAL      W5IDEN = OW4IDEN
     C                   EVAL      W5ITEM = OW4ITEM
     C                   EVAL      W5BRCH = OW4BRCH
     C                   EVAL      W5SYSM = OW4SYSM
     C                   EVAL      W5FUNT = OW4FUNT
     C                   EVAL      W5CNUM = OW4CNUM
     C                   EVAL      W5CTYP = OW4CTYP
     C                   EVAL      W5CUST = OW4CUST
     C                   MOVE      OW4DDAT       W5DDAT
     C                   MOVE      OW4VDAT       W5VDAT
     C                   MOVE      OW4MDAT       W5MDAT
     C                   EVAL      W5DEN1 = OW4DEN1
     C                   EVAL      W5DEN2 = OW4DEN2
     C                   EVAL      TempAmt= OW4AMT1
     C                   MOVE      TempAmt       W5AMT1
     C                   EVAL      TempAmt= OW4AMT2
     C                   MOVE      TempAmt       W5AMT2
     C                   EVAL      W5ARLS = OW4ARLS
     C                   EVAL      W5SSTR = PSrchStrng
 
      ** Write record to PF/SDWLSTPD
 
     C                   IF        CSD083 = 'Y'                                               CSD083
     C                   MOVE      SDWLSTDS      PONwTranDtl                                  CSD083
                                                                                              CSD083
     C                   CALL      'SD000902'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM                    PONwTranDtl                                  CSD083
                                                                                              CSD083
     C                   IF        PRTCD = '*ERROR'                                           CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ELSE                                                                 CSD083
                                                                                              CSD083
     C                   MOVEL     SDWLSTDS      PDtqMsg
     C                   EVAL      PDtqLen = 31000
 
     C                   CALL      'QSNDDTAQ'
     C                   PARM      'SDCWEDTQ'    PDtqNam
     C                   PARM      '*LIBL'       PDtqLib
     C                   PARM                    PDtqLen
     C                   PARM                    PDtqMsg
 
     C                   ENDIF                                                                CSD083
     C                   ENDIF
 
     C     ExitPgm       TAG
     C                   MOVEL     *ON           *INLR
     C                   RETURN
 
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PITranDtls
     C                   PARM                    PSrchStrng
 
      *                                                                                       CSD083
      ** Check if CSD083 is installed                                                         CSD083
      *                                                                                       CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD083 = 'Y'                                               CSD083
     C                   ELSE                                                                 CSD083
     C                   EVAL      CSD083 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
