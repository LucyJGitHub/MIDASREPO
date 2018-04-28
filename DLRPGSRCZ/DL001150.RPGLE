     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Fees activity enquiry')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL001150 - DL Fee Activity Enquiry                           *
      *                                                               *
      *  Function:  This module will show all fee attached to the     *
      *             deal.                                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL094             Date 11Jun14               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
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
 
     FDLFEEDL5  IF   E           K DISK    INFSR(*PSSR)
      ** Deal Fees Live and Historic Details
 
     FDLFEEDL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLFEEDD0:DLFEEDLL)
      ** Deal Fees Live by Deal No/Fee Code/Fee Seq
 
     FDL001150DFCF   E             WORKSTN
     F                                     SFILE(SFEES1:@@RRN)
      ** DL Fee Display File
 
      *****************************************************************
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
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * File Fra/irs instructions
     D F_FRI         E DS                  EXTNAME(SDESFFPD)
 
      * File Receive instructions
     D F_REC         E DS                  EXTNAME(SDESFRPD)
 
      * File Payment instructions
     D F_PAY         E DS                  EXTNAME(SDESFPPD)
 
      * Screen Receive instructions
     D S_REC         E DS                  EXTNAME(SDESSRPD)
 
      * Screen Payment instructions
     D S_PAY         E DS                  EXTNAME(SDESSPPD)
 
      * Screen Fra/irs instructions
     D S_FRI         E DS                  EXTNAME(SDESSFPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZA0340
     D P_MsgFile       S             10A
     D P_MsgID         S             10A
 
      ** Key Fields
     D WDealNo         S              6  0
     D WFeeCode        S              2  0
     D WFeeSeq         S              2  0
 
      ** Access Program
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCurr           S              3A
     D PReturnCode     S              7A
     D PRetCode        S             10A
     D PKeyStatus      S              7A
     D PCustomer       S              6A
     D PCust           S             10A
 
      ** Standard Subroutines
     D ZDATE           S              6  0
     D ZADATE          S              7A
     D ZDAYNO          S              5  0
     D ZFIELD          S             16A
     D ZADEC           S              2  0
 
      ** Work Variables
     D @INKC           S              1A
     D @INKL           S              1A
     D @RUN            S              1A
     D @@RRN           S              5  0
     D @@ERR           S              5  0
     D @@EOF           S              1A
     D @@CNT           S              5  0
     D CEU003          S              1A
     D DealRef         S              6A
     D FedFund         S              1A
     D ActionCode      S              1A
     D CallingPgm      S              4A
     D ProtectRcv      S              1A
     D ProtectPay      S              1A
     D Customer        S             10A
     D TranType        S              2A
     D Branch          S              3A
     D RcvCcy          S              3A
     D PayCcy          S              3A
     D RcvDate         S              5  0
     D PayDate         S              5  0
     D WPhase          S              1A
     D WAmount         S             13  0
     D KDealNo         S              6  0
     D FccyNBDP        S              1  0
 
      *****************************************************************
      /EJECT
      *
      ** DL Fee Details File
     IDLFEEDD0      01
      *
      ** DL Fee Details History File
     IDLFHSTD0      02
 
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
      ** Access Customer Details
      *
     C                   EVAL      PCust = *Blanks
     C                   MOVE      PCustomer     PCust
     C                   EXSR      SRCustDetail
 
     C                   EVAL      WPhase = 'L'
      *
      ** Stay in loop until user 'T'erminate or 'C'ancel the program
      *
     C                   DOW       WPhase <> 'T' AND
     C                             WPhase <> 'C'
 
     C                   SELECT
      ** Load Subfile
     C                   WHEN      WPhase = 'L'
     C                   EXSR      SRLoadSubFile
 
      ** Retrieve Fee detail
     C                   WHEN      WPhase = 'R'
     C                   EXSR      SRRetDetail
 
      ** Display Detail Screen
     C                   WHEN      WPhase = 'D'
     C                   EXSR      SRDspDetail
 
     C                   ENDSL
     C                   ENDDO
 
      ** Cancel
     C                   IF        WPhase = 'C'
     C                   EVAL      PReturnCode = '*CANCEL'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      ** Terminate
     C                   IF        WPhase = 'T'
     C                   EVAL      PReturnCode = '*EXIT'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadSubFile - Load Fee Subfile                              *
      *                                                               *
      *****************************************************************
     C     SRLoadSubFile BEGSR
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     0             @@RRN
     C                   EVAL      DDOPT = *Blanks
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SFEES0
     C                   EVAL      *IN97 = *OFF
      *
      **  Set file pointer on key displayed on screen.
      *
     C                   MOVEL     DDDLNO        KDealNo
     C     KDealNo       SETLL     DLFEEDL5
      *
      **  Read a Valid Transaction
      *
     C                   EXSR      SRRdTran
      *
      **  set up message 'no data to display'
      *
     C                   EVAL      *IN80 = *OFF
     C                   IF        @@EOF = 'Y'
     C                   EVAL      *IN80 = *ON
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   EVAL      *IN98 = *ON
     C                   EVAL      @@ERR = 0
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C                   DOW       *IN98 = *ON or
     C                             @@ERR <> 0
      *
      **  Initialise count of records written to subfile page.
      *
     C                   IF        @@ERR = 0
     C                   EVAL      @@CNT = 0
     C                   ENDIF
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C                   DOW       @@EOF <> 'Y' and
     C                             @@CNT < 13   and
     C                             @@ERR = 0
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
      *
      **  Format transaction fields for output
      *
     C                   IF        *IN01 = *ON
     C                   EXSR      SRFmtTran
     C                   ELSE
     C                   IF        *IN02 = *ON
     C                   EXSR      SRFmtHTran
     C                   ENDIF
     C                   ENDIF
      *
      **  Write the transaction to the subfile.
      *
     C                   Z-ADD     @@RRN         DDSFRN
     C                   WRITE     SFEES1
      *
      **  Read a valid Transaction
      *
     C                   EXSR      SRRdTran
     C                   ENDDO
      *
      **  If count is greater more than 1 page, display 'Rollup/Rolldown'
      *
     C                   IF        @@CNT > 14
     C                   EVAL      *IN79 = *ON
     C                   ELSE
     C                   EVAL      *IN79 = *OFF
     C                   ENDIF
      *
      **  Set up footer toggle text and write the footer
      *
     C                   WRITE     SFEEF1
      *
      **  Write the message subfile
      *
     C                   WRITE     SFEEM0
      *
      **  If there is no data to display, set on SFLCLR condition and
      **  write the subfile control record
      *
     C                   IF        @@CNT = 0
     C                   EVAL      *IN97 = *ON
     C                   WRITE     SFEES0
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      @@RRN = 1
     C                   EVAL      DDSFRN = 1
      *
      **  write to the subfile with non-display set on
      *
     C                   EVAL      *IN93 = *ON
     C                   WRITE     SFEES1
     C                   EVAL      *IN93 = *OFF
     C                   WRITE     SFEES0
     C                   ELSE
      *
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C                   WRITE     SFEES0
     C                   ENDIF
      *
      **  Read the subfile control record to determine whether records
      **  have been selected or whether ROLLUP is required.
      *
     C                   READ      SFEES0                                 99
      *
      **  If F3, bypass further processing.
      *
     C                   IF        *INKC = *ON
     C                   EVAL      WPhase = 'T'
     C                   GOTO      ELoadSubFile
     C                   END
      *
      **  If F12, bypass further processing.
      *
     C                   IF        *INKL = *ON
     C                   EVAL      WPhase = 'C'
     C                   GOTO      ELoadSubFile
     C                   END
      *
      ** Read Subfile Change
      *
     C                   EXSR      SRRedSubFile
 
     C                   ENDDO
 
     C     ELoadSubFile  ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRdTran - Read a transaction                                 *
      *                                                               *
      *****************************************************************
     C     SRRdTran      BEGSR
      *
      **  Reset End of File and skip record indicator
      *
     C                   MOVE      *BLANK        @@EOF
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
     C                   DOU       @@EOF = 'Y' or
     C                             DFDLNO <> 0  and
     C                             @@ERR = *ZERO and
     C                             DFRECI = 'D'
      *
      **  Read the file
      *
     C                   EVAL      *IN01 = *OFF
     C                   EVAL      *IN02 = *OFF
     C     KDealNo       READE     DLFEEDL5                               96
      *
      ** End of File
      *
     C                   IF        *IN96 = *ON
     C                   EVAL      @@EOF = 'Y'
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     ERdTran       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtTran - Format Subfile Details of Live Record             *
      *                                                               *
      *****************************************************************
     C     SRFmtTran     BEGSR
 
      ** Transaction reference
 
     C                   EVAL      DDRECI = DFRECI
     C                   EVAL      DDCUST = *Blanks
     C                   MOVEL     DFCUST        DDCUST
     C                   EVAL      DDFSEQ = *Blanks
     C                   MOVEL     DFFSEQ        DDFSEQ
     C                   EVAL      DDFCOD = *Blanks
     C                   MOVEL     DFFCOD        DDFCOD
     C                   EVAL      DDSCCY = DFFCCY
      *
      ** Fee Indicator
      *
     C                   IF        DFDTYP = 'IT' OR
     C                             DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR
     C                             DFDTYP = 'CD'
     C                   EVAL      DDPTFI = 'P'
     C                   ELSE
     C                   EVAL      DDPTFI = 'R'
     C                   ENDIF
      *
      ** Determine number of decimal places
      *
     C                   EVAL      PCurr = DDSCCY
     C                   EXSR      SRNumDecPlc
     C                   EVAL      FccyNBDP = A6NBDP
      *
      ** Format Fee Amount
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
 
     C                   IF        DFFAMT < 0
     C                   Z-SUB     DFFAMT        WAmount
     C                   MOVE      WAmount       ZFIELD
     C                   EVAL      DDSIGN = '-'
     C                   ELSE
     C                   MOVE      DFFAMT        ZFIELD
     C                   EVAL      DTSIGN = ' '
     C                   ENDIF
 
     C                   EXSR      ZEDIT2
     C                   EVAL      DDSAMT = *Blanks
     C                   MOVE      ZFIELD        DDSAMT
      *
      ** Format Fee Start Date
      *
     C                   MOVEL     DFPSTD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DDSDAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtHTran - Format Subfile Details of Historic Record        *
      *                                                               *
      *****************************************************************
     C     SRFmtHTran    BEGSR
 
      ** Transaction reference
 
     C                   EVAL      DDRECI = HIRECI
     C                   EVAL      DDCUST = *Blanks
     C                   MOVEL     HICUST        DDCUST
     C                   EVAL      DDFSEQ = *Blanks
     C                   MOVEL     HIFSEQ        DDFSEQ
     C                   EVAL      DDFCOD = *Blanks
     C                   MOVEL     HIFCOD        DDFCOD
     C                   EVAL      DDSCCY = HIFCCY
      *
      ** Fee Indicator is always 'R'eceivable
      *
     C                   EVAL      DDPTFI = 'H'
      *
      ** Determine number of decimal places
      *
     C                   EVAL      PCurr = HIFCCY
     C                   EXSR      SRNumDecPlc
     C                   EVAL      FccyNBDP = A6NBDP
      *
      ** Format Fee Amount
      *
     C                   MOVE      *BLANK        ZFIELD
     C                   Z-ADD     FccyNBDP      ZADEC
 
     C                   IF        HIAMTS < 0
     C                   Z-SUB     HIAMTS        WAmount
     C                   MOVE      WAmount       ZFIELD
     C                   EVAL      DDSIGN = '-'
     C                   ELSE
     C                   MOVE      HIAMTS        ZFIELD
     C                   EVAL      DTSIGN = ' '
     C                   ENDIF
 
     C                   EXSR      ZEDIT2
     C                   EVAL      DDSAMT = *Blanks
     C                   MOVE      ZFIELD        DDSAMT
      *
      ** Format Fee Start Date
      *
     C                   MOVEL     HIHDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DDSDAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRedSubFile - Read Subfile Change                            *
      *                                                               *
      *****************************************************************
     C     SRRedSubFile  BEGSR
      *
      **  Read the subfile for selected records
      **  Only process those for which the option field is blank.
      *
     C                   DOU       *IN99 = *ON or
     C                             DDOPT <> *BLANK
 
     C                   READC     SFEES1                                 99
      *
      **  Validate option
      *
     C                   IF        *IN99 = *OFF
 
      ** Clear program message queue
     C                   CALL      'ZA0250'
     C                   EXSR      SRValidate
      *
      ** Activate SFLNXTCHG when option is selected
      *
     C                   EVAL      *IN91 = *ON
     C                   UPDATE    SFEES1
     C                   EVAL      *IN91 = *OFF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Key                                     *
      *                                                               *
      *****************************************************************
     C     SRValidate    BEGSR
 
     C                   EVAL      @@ERR = 0
     C                   EVAL      *IN92 = *OFF
      *
      **  Validate if action code is 'E'
      *
     C                   IF        DDOPT <> 'E'  and
     C                             DDOPT <> *Blanks
     C                   EVAL      @@ERR = @@ERR + 1
     C                   EVAL      *IN92 = *ON
     C                   EVAL      P_MsgID = 'USR4700'
     C                   EXSR      SNDM@P
     C                   ENDIF
      *
      ** Validate if selected fee record is historic
      *
     C                   IF        @@ERR  = 0    AND
     C                             DDOPT  = 'E'  AND
     C                             DDPTFI = 'H'
     C                   EVAL      @@ERR = @@ERR + 1
     C                   EVAL      *IN92 = *ON
     C                   EVAL      P_MsgID = 'USR4701'
     C                   EXSR      SNDM@P
     C                   ENDIF
      *
      ** If option for record selected is successfully validated,
      ** move to Retrive Phase
      *
     C                   IF        @@ERR = 0  AND
     C                             DDOPT = 'E'
     C                   EVAL      WPhase = 'R'
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetDetail - Retrieve Fee Details                            *
      *                                                               *
      *****************************************************************
     C     SRRetDetail   BEGSR
 
     C                   MOVEL     DDDLNO        WDealNo
     C                   MOVEL     DDFCOD        WFeeCode
     C                   MOVEL     DDFSEQ        WFeeSeq
 
     C     KFee          CHAIN     DLFEEDL6
      *
      ** If not found, send error message from the screen
      *
     C                   IF        NOT %FOUND(DLFEEDL6)
     C                   EVAL      WPhase = 'L'
     C                   ELSE
      *
      ** Format Details for output
      *
     C                   EXSR      SRFmtDet
     C                   EVAL      WPhase = 'D'
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFmtDet - Format Fee Details for Output                      *
      *                                                               *
      *****************************************************************
     C     SRFmtDet      BEGSR
      *
      ** Deal Fee details
      *
     C                   EVAL      DTCNUM = *Blanks
     C                   MOVEL     DFCUST        DTCNUM
     C                   EVAL      DTDEAL = *Blanks
     C                   MOVEL     DFDLNO        DTDEAL
     C                   EVAL      DTFSEQ = *Blanks
     C                   MOVEL     DFFSEQ        DTFSEQ
     C                   EVAL      DTBRCA = DFBRCA
     C                   EVAL      DTFCOD = *Blanks
     C                   MOVEL     DFFCOD        DTFCOD
     C                   EVAL      DTFCCY = DFFCCY
     C                   IF        DFDTYP = 'IT' OR
     C                             DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR
     C                             DFDTYP = 'CD'
     C                   EVAL      DTPTFN = 'PAYABLE'
     C                   ELSE
     C                   EVAL      DTPTFN = 'RECEIVABLE'
     C                   ENDIF
      *
      ** Determine number of decimal places
      *
     C                   EVAL      PCurr = DTFCCY
     C                   EXSR      SRNumDecPlc
     C                   EVAL      FccyNBDP = A6NBDP
     C                   Z-ADD     FccyNBDP      ZADEC
      *
      ** Format Fee Amount
      *
     C                   MOVE      *BLANK        ZFIELD
 
     C                   IF        DFFAMT < 0
     C                   Z-SUB     DFFAMT        WAmount
     C                   MOVE      WAmount       ZFIELD
     C                   EVAL      DTSIGN = '-'
     C                   ELSE
     C                   MOVE      DFFAMT        ZFIELD
     C                   EVAL      DTSIGN = ' '
     C                   ENDIF
 
     C                   EXSR      ZEDIT2
     C                   EVAL      DTAMNT = *Blanks
     C                   MOVE      ZFIELD        DTAMNT
      *
      ** Format Outstanding Amount
      *
     C                   MOVE      *BLANK        ZFIELD
 
     C                   IF        DFAMTO < 0
     C                   Z-SUB     DFAMTO        WAmount
     C                   MOVE      WAmount       ZFIELD
     C                   EVAL      DTSGN2 = '-'
     C                   ELSE
     C                   MOVE      DFAMTO        ZFIELD
     C                   EVAL      DTSGN2 = ' '
     C                   ENDIF
 
     C                   EXSR      ZEDIT2
     C                   EVAL      DTOAMT = *Blanks
     C                   MOVE      ZFIELD        DTOAMT
      *
      ** Format Total Accrue Amount to Date
      *
     C                   MOVE      *BLANK        ZFIELD
 
     C                   IF        DFADAT < 0
     C                   Z-SUB     DFADAT        WAmount
     C                   MOVE      WAmount       ZFIELD
     C                   EVAL      DTSGN3 = '-'
     C                   ELSE
     C                   MOVE      DFADAT        ZFIELD
     C                   EVAL      DTSGN3 = ' '
     C                   ENDIF
 
     C                   EXSR      ZEDIT2
     C                   EVAL      DTTACR = *Blanks
     C                   MOVE      ZFIELD        DTTACR
      *
      ** Format Settled Amount
      *
     C                   MOVE      *BLANK        ZFIELD
 
     C                   IF        DFFAMT < 0
     C                   Z-SUB     DFFAMT        WAmount
     C                   MOVE      WAmount       ZFIELD
     C                   EVAL      DTSGN4 = '-'
     C                   ELSE
     C                   MOVE      DFFAMT        ZFIELD
     C                   EVAL      DTSGN4 = ' '
     C                   ENDIF
 
     C                   EXSR      ZEDIT2
     C                   EVAL      DTSAMT = *Blanks
     C                   MOVE      ZFIELD        DTSAMT
      *
      ** Format Date Fields
      *
     C                   MOVEL     DFPSTD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DTSDAT
 
     C                   MOVEL     DFPEND        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DTEDAT
 
     C                   MOVEL     DFNPYD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZADATE        DTNPYD
 
     C                   EVAL      DTPYON = DFPYON
     C                   EVAL      DTFREQ = DFFREQ
 
     C                   IF        DFDYIM <> *ZERO
     C                   MOVE      DFDYIM        DTDYIM
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDspDetail - Display Fee Detail                              *
      *                                                               *
      *****************************************************************
     C     SRDspDetail   BEGSR
      *
      ** Switch on indicator if settlement details is available
      *
     C                   EVAL      *IN32 = *ON
      *
     C                   WRITE     DETAIL
      *
      ** Stay in detail screen until exit is requested
      *
     C                   DOW       WPhase = 'D'
     C                   READ      DETAIL
      *
      ** If F3 is press, exit the screen
      *
     C                   IF        *INKC = *ON
     C                   EVAL      WPhase = 'T'
     C                   ENDIF
      *
      ** If F12 is press, back to subfile screen
      *
     C                   IF        *INKL = *ON
     C                   EVAL      WPhase = 'L'
     C                   ENDIF
      *
      ** If F14 is press, display settlement details
      *
     C                   IF        *INKN = *ON
     C                   EXSR      SRDspSDet
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDspSDet - Display Settlement Details                        *
      *                                                               *
      *****************************************************************
     C     SRDspSDet     BEGSR
 
     C                   EXSR      SRSetSSDet
     C                   EVAL      @INKC = '0'
     C                   EVAL      @INKL = '0'
      *
      ** Stay in Settlement Screen until F12 or F3 is press
      *
     C                   DOW       @INKC = '0' AND
     C                             @INKL = '0'
 
     C                   CALLB     'ZASETINSIN'
      *
      **  Inputs
      *
     C                   PARM      *BLANK        PRetCode
     C                   PARM                    ActionCode
     C                   PARM                    DealRef
     C                   PARM                    ProtectPay
     C                   PARM                    ProtectRcv
     C                   PARM                    CallingPgm
     C                   PARM                    PayCcy
     C                   PARM                    RcvCcy
     C                   PARM                    Customer
     C                   PARM                    TranType
     C                   PARM      *BLANK        FedFund
     C                   PARM                    Branch
     C                   PARM                    RcvDate
     C                   PARM                    PayDate
     C                   PARM                    S_Pay
     C                   PARM                    S_Rec
     C                   PARM                    S_Fri
      *
      ***  Outputs
      *
     C                   PARM      *Blanks       F_Pay
     C                   PARM      *Blanks       F_REC
     C                   PARM      *Blanks       F_FRI
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ** Database error, terminate processing
      *
     C                   IF        PRetCode <> *Blanks
     C                   EVAL      DBFILE = 'ZASETINSIN'
     C                   EVAL      DBASE =  003
     C                   EVAL      DBKEY = DealRef
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        @INKC = '1'
     C                   EVAL      WPhase = 'T'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSetSSDet - Set Settlement Instructions                      *
      *                                                               *
      *****************************************************************
     C     SRSetSSDet    BEGSR
      *
      ** Settlement Instructions
      *
     C                   EVAL      ActionCode = 'E'
     C                   EVAL      CallingPgm = 'DL001150'
     C                   EVAL      ProtectRcv = 'Y'
     C                   EVAL      ProtectPay = 'Y'
     C                   EVAL      Customer = *Blanks
     C                   MOVEL     DFCUST        Customer
     C                   EVAL      TranType = 'F1'
     C                   EVAL      Branch = DFBRCA
     C                   EVAL      RcvCcy = DFFCCY
     C                   EVAL      PayCcy = DFFCCY
     C                   EVAL      RcvDate = DFPSTD
     C                   EVAL      PayDate = DFPEND
 
     C                   IF        CEU003 = 'Y'
     C                   IF        DFDTYP = 'IT' OR
     C                             DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR
     C                             DFDTYP = 'CD'
     C                   EVAL      DDPSCY = DFSCCY
     C                   ELSE
     C                   EVAL      DDRSCY = DFSCCY
     C                   ENDIF
     C                   EVAL      DDIC72 = DFICCY
     C                   ELSE
     C                   IF        DFDTYP = 'IT' OR
     C                             DFDTYP = 'TD' OR
     C                             DFDTYP = 'CI' OR
     C                             DFDTYP = 'CD'
     C                   EVAL      DDPSCY = DFFCCY
     C                   ELSE
     C                   EVAL      DDRSCY = DFFCCY
     C                   ENDIF
     C                   EVAL      DDIC72 = *Blanks
     C                   ENDIF
 
     C                   EVAL      DDRSTM = *Blanks
     C                   MOVEL     DFRSTM        DDRSTM
     C                   EVAL      DDRONX = DFRONS
     C                   EVAL      DDRIBN = DFRIBN
     C                   EVAL      DDRIBA = DFRIBA
 
     C                   EVAL      DDROBN = *Blanks
     C                   IF        DFROBN <> *ZERO
     C                   MOVEL     DFROBN        DDROBN
     C                   ENDIF
 
     C                   EVAL      DDROCN = *Blanks
     C                   IF        DFROCN <> *ZERO
     C                   MOVEL     DFROCN        DDROCN
     C                   ENDIF
 
     C                   EVAL      DDPSTM = *Blanks
     C                   MOVEL     DFPSTM        DDPSTM
     C                   EVAL      DDPONX = DFPONS
     C                   EVAL      DDPIBN = DFPIBN
     C                   EVAL      DDPIBA = DFPIBA
     C                   EVAL      DDPOBN = *Blanks
 
     C                   IF        DFPOBN <> *ZERO
     C                   MOVEL     DFPOBN        DDPOBN
     C                   ENDIF
 
     C                   EVAL      DDPOCN = *Blanks
     C                   IF        DFPOCN <> *ZERO
     C                   MOVEL     DFPOCN        DDPOCN
     C                   ENDIF
 
     C                   EVAL      DDRCRN = DFRCRN
     C                   EVAL      DDRCRA = DFRCRA
     C                   EVAL      DDRVNO = DFRVNO
     C                   EVAL      DDAWBN = DFAWBN
     C                   EVAL      DDAWBA = DFAWBA
     C                   EVAL      DDBENN = DFBENN
     C                   EVAL      DDBENA = DFBENA
     C                   EVAL      DDDTP1 = DFDTP1
     C                   EVAL      DDDTP2 = DFDTP2
     C                   EVAL      DDDTP3 = DFDTP3
     C                   EVAL      DDDTP4 = DFDTP4
     C                   EVAL      DDDCHG = DFDCHG
     C                   EVAL      DDBTB1 = DFBTB1
     C                   EVAL      DDBTB2 = DFBTB2
     C                   EVAL      DDBTB3 = DFBTB3
     C                   EVAL      DDBTB4 = DFBTB4
     C                   EVAL      DDBTB5 = DFBTB5
     C                   EVAL      DDBTB6 = DFBTB6
     C                   EVAL      DDCVMR = DFCVMR
 
     C                   EVAL      DealRef = *Blanks
     C                   MOVEL     DDDLNO        DealRef
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNumDecPlc - Determine Number of Decimal Places              *
      *                                                               *
      *****************************************************************
     C     SRNumDecPlc   BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PReturnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** Database error
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   EVAL      DBASE = 004
     C                   MOVEL     PCurr         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustDetail - Access customer Details                        *
      *                                                               *
      *****************************************************************
     C     SRCustDetail  BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM                    PReturnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      '*CNUM  '     PKeyStatus
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error
      *
     C                   IF        PReturnCode <> *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   EVAL      DBASE = 005
     C                   MOVEL     PCust         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Setup Screen Header
      *
     C                   EVAL      DDCNUM = PCustomer
     C                   EVAL      DDCNM2 = BBCSSN
     C                   EVAL      DDCNAM = BBCRNM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZDATE2 - Convert Midas DayNo to DDMMMYY                       *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ZEDIT2 - Format numeric fields                                *
      *                                                               *
      *****************************************************************
     C     ZEDIT2        BEGSR
 
     C                   CALLB     'ZEDIT2'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SNDM@P - Send a message to detail screen                      *
      *                                                               *
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      ** Add error message to array passed to detail screen
      *
     C                   CALL      'ZA0340'
     C                   PARM      'GBSDUSRMSG'  P_MsgFile
     C                   PARM                    P_MsgID
      *
     C                   ENDSR
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
 
     C     *entry        PLIST
     C                   PARM                    PReturnCode
     C                   PARM                    DDDLNO
     C                   PARM                    PCustomer
     C                   PARM                    DDBRCA
      *
      ** Initialize program name
     C                   EVAL      DBPGM = 'DL001150'
      *
      ** Move workstation ID to screen field.
     C                   EVAL      DDWID = PsJobName
     C                   EVAL      DDUSER = PsUser
      *
     C                   EVAL      *IN94 = *ON
     C                   EVAL      DDPGMQ = '*'
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtCd <> *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   EVAL      DBASE = 001
     C                   MOVEL     POptn         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Check whether SAR CEU003 is installed or not.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtCd =  *BLANKS
     C                   EVAL      CEU003 = 'Y'
     C                   ELSE
     C                   EVAL      CEU003 = 'N'
 
     C                   IF        PRtCd <> '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   EVAL      DBASE = 002
     C                   MOVEL     'CEU003'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Key List
      *
     C     KFee          KLIST
     C                   KFLD                    WDealNo
     C                   KFLD                    WFeeCode
     C                   KFLD                    WFeeSeq
 
     C                   ENDSR
 
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
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
