     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Rates Input Module')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDYRATSIN - Yield Rates Input Module                         *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Yield Rates Details.                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS008             Date 16Jun04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F/COPY WNCPYSRC,SDYRATSF01
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  LR  - Last record indicator (program termination)            *
      *  U7  - DB error processing indicator                          *
      *  U8  - DB error processing indicator                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRDSPINI   - Display Initial Screen                          *
      *  SRROLL     - Display Previous or Next Yield Rates Details    *
      *  SRBROWSE   - Build Browse Subfile                            *
      *  SRRDNXTB   - Read Next Browse                                *
      *  SRPROCESS  - Processes Input                                 *
      *  SRVALIDATE - Validate Input                                  *
      *  SRRTVREC   - Retrieve Yield Rates Details                    *
      *  SRCONVERT  - Convert Yield Rates Details in Screen Format    *
      *  SRCONFIRM  - Confirm Screen Inputs                           *
      *  SRUPDATE   - Update Database                                 *
      *  SRDELETE   - Delete Record                                   *
      *  SREXITC    - Exit Confirmation Screen                        *
      *  SRSETFSTS  - Set Field Status                                *
      *  SRRESETERR - Reset error fields                              *
      *  SRSNDERR   - Send Error Messages from the called Module      *
      *  SREND      - Program Termination                             *
      *  SRCANCEL   - Cancel Screen Inputs                            *
      *  *INZSR     - Program Initialisation                          *
      *  *PSSR      - DB Error Processing                             *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layou
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARR1
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Maturity Date
     D PMatAr          S              7    DIM(98)
 
      ** Maturity Date
     D PDFcAr          S             14    DIM(98)
 
      ** Current Yield Rates Detail in File Format
     D CrYRFilFmt    E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(C_)
 
      ** Previous Yield Rates Detail in File Format
     D PrvYRFilFmt   E DS                  EXTNAME(SDVYRATPD)
     D                                     PREFIX(P_)
 
      ** Current Yield Rates Detail in Screen Format
     D CurYRScnFmt   E DS                  EXTNAME(SDYRATPD)
 
      ** Previous Yield Rates Detail in Screen Format
     D PrvYRScnFmt   E DS                  EXTNAME(SDYRATPD)
     D                                     PREFIX(P_)
 
      ** Current Yield Rates Extra Data
     D CurYRExtDta   E DS                  EXTNAME(SDYREXPD)
 
      ** Valid Yield Rates Detail File Format
     D ValidYRDets   E DS                  EXTNAME(SDVYRATPD)
 
      ** Error indicators
     D OKYRDets      E DS                  EXTNAME(SDEYRATPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                              CAS008
      ** External DS for switchable features                                                  CAS008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS008
 
      ** First DS for Access Programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** Build subfile
     D PBDSFL          S              1A
 
      ** Error message reference
     D PERRMS          S              7A
 
      ** Read backwards in roll
     D PRDBCK          S              1A
 
      ** Read forwards in roll
     D PRDFWD          S              1A
 
      ** Read subfile
     D PRDSFL          S              1A
 
      ** Enable Key fields and action code
     D PEKYFD          S              1A
 
      ** Enable F7, F8, F10 and F15 in Command Narrative
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKP          S              1A
 
      ** Function Keys - 3,7,8,10,12 and 15
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
 
      ** Screen / function
     D W@SCRN          S              1A
 
      ** Mode of operation
     D PModeOfOP       S              6A
 
      ** Index of errors and warnings
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Other workfields
     D WIdx_PVAL       S              3P 0
     D PrvN_Warn       S              3P 0
     D WRDNXTB         S              1A
     D WPRVCONV        S              1A   INZ('N')
     D POPSEL          S              1A
     D PYLDC           S              5A
     D PYCCY           S              3A
     D PYICM           S              1A
     D PYCFQ           S              1A
     D PSPDY           S              1A                                                      CAS008
     D PFOTRID         S             20A
     D WINICA          S              1A
     D WBRWCA          S              1A
     D WSFLRD          S              1A
     D PKYCFQ          S              1A
     D WkPrvCFQ        S              1A
     D WkPrvACT        S              1A
     D WkPrvYLC        S              5A
     D WkPrvCCY        S              3A
     D WkPrvICM        S              1A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Parameter fields used by access object
     D PRTCD           S              7
     D POPTN           S              7
     D PSard           S              6                                                       CAS008
                                                                                              CAS008
      ** Switchable Feature Flag                                                              CAS008
     D CAS008          S              1                                                       CAS008
 
     D/COPY WNCPYSRC,SDYRATSD01
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Issue rollback to clear any possible updates in window functions
 
     C                   IF        PINKL = TRUE
     C                   ROLBK
     C                   ENDIF
 
      ** Read next browse subfile record
 
     C                   IF        W@SCRN = 'R'
     C                   EXSR      SRRDNXTB
     C                   ENDIF
 
      ** Do while screen: Initial Screen
 
     C                   DOW       W@SCRN = 'I'
     C                   EXSR      SRDSPINI
     C                   ENDDO
     C/COPY WNCPYSRC,SDYRATSC01
 
      ** Confimation screen
 
     C                   IF        W@SCRN = 'C'
     C                   EXSR      SRCONFIRM
     C                   ENDIF
 
      ** Do File updates
 
     C                   IF        W@SCRN = 'U'
     C                   EXSR      SRUPDATE
     C                   ENDIF
 
      ** Terminate program
 
     C                   IF        W@SCRN = 'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDSPINI    - Display Initial Screen                          *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SRSETFSTS   - Set Field Status                                *
      * SDYRATDSP   - Yield Rate Display Module                       *
      * SRRESETERR  - Reset error fields                              *
      * SREND       - Program Termination                             *
      * SRCANCEL    - Cancel Screen Inputs                            *
      * SRROLL      - Display Previous or Next Yield Rates Details    *
      * SRDELETE    -  Delete Record                                  *
      * SRBROWSE    - Build Browse Subfile                            *
      * SRPROCESS   - Processes Input                                 *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     SRDSPINI      BEGSR
 
      ** Save previous screen
 
     C                   EVAL      PrvYRScnFmt = CurYRScnFmt
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn
 
      ** Set function key narratives and field status
 
     C                   EXSR      SRSETFSTS
 
      ** Write/Read Display Screen
 
     C                   CALLB     'SDYRATDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CurYRScnFmt
     C                   PARM                    PMatAr
     C                   PARM                    PDFcAr
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIdAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIdAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    OKYRDets
     C                   PARM                    PEKYFD
     C                   PARM                    WriteOnly
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKG
     C                   PARM      FALSE         PINKH
     C                   PARM      FALSE         PINKJ
     C                   PARM      FALSE         PINKL
     C                   PARM      FALSE         PINKP
 
      ** Reset Error fields
 
     C                   EXSR      SRRESETERR
 
      ** Process function keys
 
     C     PINKC         CASEQ     TRUE          SREND
     C     PINKL         CASEQ     TRUE          SRCANCEL
     C     PINKG         CASEQ     TRUE          SRROLL
     C     PINKH         CASEQ     TRUE          SRROLL
     C     PINKJ         CASEQ     TRUE          SRDELETE
     C     PINKP         CASEQ     TRUE          SRBROWSE
     C                   CAS                     SRPROCESS
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRROLL      - Display Previous or Next Yield Rates Details    *
      *                                                               *
      * Called By : SRDSPINI subroutine                               *
      *                                                               *
      * Calls :                                                       *
      * SDYRATRED   - Yield Rate Read Module                          *
      * SRSNDERR    - Send Error Messages from the called Module      *
      * SRRTVREC    - Retrieve Yield Rates Details                    *
      * SRCONVERT   - Convert Yield Rates Details in Screen Format    *
      *                                                               *
      *****************************************************************
 
     C     SRROLL        BEGSR
 
      ** Initialise read indicators
 
     C                   EVAL      PRDBCK = *BLANKS
     C                   EVAL      PRDFWD = *BLANKS
 
      ** Set read indicator
 
     C                   IF        PINKG = TRUE
     C                   EVAL      PRDBCK = 'Y'
     C                   ELSE
     C                   EVAL      PRDFWD = 'Y'
     C                   ENDIF
 
      ** Set action code to 'A' if entered blank
 
     C                   IF        #0ACTN = *BLANK
     C                   EVAL      #0ACTN = 'A'
     C                   ENDIF
 
      ** Read Yield Rates Details
 
     C                   CALLB     'SDYRATRED'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    #0ACTN
     C                   PARM                    #0YLDC
     C                   PARM                    #0YCCY
     C                   PARM                    #0YICM
     C                   PARM                    #0YCFQ
     C                   PARM                    #0SPDY                                       CAS008
     C                   PARM                    PRDFWD
     C                   PARM                    PRDBCK
     C                   PARM      *BLANK        PERRMS
 
      ** Error message returned from read, send it to detail screen
 
     C                   IF        PERRMS <> *BLANK
     C                   EXSR      SRSNDERR
     C                   ENDIF
 
      ** Convert record to screen format
 
     C                   IF        PERRMS = *BLANK
     C                   EXSR      SRRTVREC
 
      ** No error retrieving the record
 
     C                   IF        (OKACTN = 'Y') AND (OKYLDC = 'Y') AND
     C                             (OKYCCY = 'Y') AND (OKYICM = 'Y') AND
     C                             (OKYCFQ = 'Y')
     C                             AND CAS008 = 'N'                                           CAS008
     C                             OR (OKACTN = 'Y') AND (OKYLDC = 'Y')                       CAS008
     C                             AND (OKYCCY = 'Y') AND (OKYICM = 'Y')                      CAS008
     C                             AND (OKYCFQ = 'Y') AND (OKSPDY = 'Y')                      CAS008
     C                             AND CAS008 = 'Y'                                           CAS008
 
      ** Save previous yield rates details
 
     C                   EVAL      PrvYRFilFmt =  CrYRFilFmt
 
      ** Convert to screen format
 
     C                   EXSR      SRCONVERT
     C                   ENDIF
 
      ** Display Record
 
     C                   EVAL      W@SCRN = 'I'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBROWSE    - Build Browse Subfile                            *
      *                                                               *
      * Called By : SRDSPINI subroutine                               *
      *                                                               *
      * Calls :                                                       *
      * SDYRATBRW   - Yield Rate Browse Module                        *
      * SREND       - Program Termination                             *
      * SRCANCEL    - Cancel Screen Inputs                            *
      * SRSNDERR    - Send Error Messages from the called Module      *
      *                                                               *
      *****************************************************************
 
     C     SRBROWSE      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   EVAL      WRDNXTB = *BLANK
     C                   EVAL      WSFLRD = 'N'
 
     C                   CALLB     'SDYRATBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      'Y'           PBDSFL
     C                   PARM      *BLANK        PRDSFL
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        POPSEL
     C                   PARM      *BLANK        PYLDC
     C                   PARM      *BLANK        PYCCY
     C                   PARM      *BLANK        PYICM
     C                   PARM      *BLANK        PYCFQ
     C                   PARM      *BLANK        PSPDY                                        CAS008
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKL
 
     C                   SELECT
 
      ** F3 taken
 
     C     PINKC         WHENEQ    TRUE
     C                   EXSR      SREND
 
      ** F12 taken
 
     C     PINKL         WHENEQ    TRUE
     C                   EXSR      SRCANCEL
 
      ** Error message returned from calling BRW
 
     C                   OTHER
     C                   IF        PERRMS <> *BLANKS
     C                   EXSR      SrSNDERR
     C                   ELSE
 
      ** No error, read selected record
 
     C                   EVAL      WRDNXTB = 'Y'
     C                   EVAL      W@SCRN = 'R'
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRDNXTB    - Read Next Browse                                *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SDYRATBRW   - Yield Rate Browse Module                        *
      * SRSNDERR    - Send Error Messages from the called Module      *
      * SRRTVREC    - Retrieve Yield Rates Details                    *
      * SRCONVERT   - Convert Yield Rates Details in Screen Format    *
      *                                                               *
      *****************************************************************
 
     C     SRRDNXTB      BEGSR
 
     C                   CALLB     'SDYRATBRW'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        PBDSFL
     C                   PARM      'Y'           PRDSFL
     C                   PARM      *BLANK        PERRMS
     C                   PARM      *BLANK        POPSEL
     C                   PARM      *BLANK        PYLDC
     C                   PARM      *BLANK        PYCCY
     C                   PARM      *BLANK        PYICM
     C                   PARM      *BLANK        PYCFQ
     C                   PARM      *BLANK        PSPDY                                        CAS008
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKL
 
      ** Error message returned from calling BRW
 
     C                   IF        PERRMS <> *BLANKS
     C                   EXSR      SRSNDERR
     C                   ENDIF
 
      ** No error
 
     C                   IF        PERRMS  = *BLANK
 
      ** Retrieve and Convert Yield Rates Details
 
     C                   IF        POPSEL <> *BLANK
 
     C                   EVAL      #0ACTN = POPSEL
     C                   EVAL      #0YLDC = PYLDC
     C                   EVAL      #0YCCY = PYCCY
     C                   EVAL      #0YICM = PYICM
     C                   EVAL      #0YCFQ = PYCFQ
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                   EVAL      #0SPDY = PSPDY                                             CAS008
     C                   ENDIF                                                                CAS008
 
     C                   EXSR      SRRTVREC
 
      ** No error retrieving the record
 
     C                   IF        (OKACTN = 'Y') AND (OKYLDC = 'Y') AND
     C                             (OKYCCY = 'Y') AND (OKYICM = 'Y') AND
     C                             (OKYCFQ = 'Y')
     C                             AND CAS008 = 'N'                                           CAS008
     C                             OR (OKACTN = 'Y') AND (OKYLDC = 'Y')                       CAS008
     C                             AND (OKYCCY = 'Y') AND (OKYICM = 'Y')                      CAS008
     C                             AND (OKYCFQ = 'Y') AND (OKSPDY = 'Y')                      CAS008
     C                             AND CAS008 = 'Y'                                           CAS008
 
      ** Save previous yield rates details
 
     C                   EVAL      PrvYRFilFmt = CrYRFilFmt
 
      ** Convert to screen format
 
     C                   EXSR      SRCONVERT
     C                   ENDIF
 
      ** Set an indicator that a subfile record has been read
 
     C                   EVAL      WSFLRD = 'Y'
     C                   ELSE
     C                   EVAL      WRDNXTB = *BLANK
 
      ** All records that have been selected were already read, clear
      ** out screen fields
 
     C                   IF        (PrvYRScnFmt = CurYRScnFmt) AND
     C                             (WSFLRD = 'Y')
     C                   CLEAR                   CurYRScnFmt
     C                   MOVEA     *BLANKS       PMatAr
     C                   MOVEA     *BLANKS       PDFcAr
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Goto initial screen
 
     C                   EVAL      W@SCRN = 'I'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROCESS   - Processes Input                                 *
      *                                                               *
      * Called By : SRDSPINI                                          *
      *                                                               *
      * Calls :                                                       *
      * SRVALIDATE  - Validate Input                                  *
      *                                                               *
      *****************************************************************
 
     C     SRPROCESS     BEGSR
 
      ** If Action 'E' or 'D' and still have record to read on browse, read
      ** next browse record
 
     C                   IF        (WRDNXTB = 'Y') AND (#0ACTN = 'E') OR
     C                             (WRDNXTB = 'Y') AND (#0ACTN = 'D')
     C                   EVAL      W@SCRN = 'R'
     C/COPY WNCPYSRC,SDYRATSC02
     C                   ELSE
 
      ** Validate Input
 
     C                   EXSR      SRVALIDATE
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVALIDATE  - Validate Input                                  *
      *                                                               *
      * Called By : SRPROCESS subroutine                              *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERR  - Reset error fields                              *
      * SRRTVREC    - Retrieve Yield Rates Details                    *
      * SRCONVERT   - Convert Yield Rates Details in Screen Format    *
      * SDYRATVAL   - Yield Rate Validation Module                    *
      *                                                               *
      *****************************************************************
 
     C     SRVALIDATE    BEGSR
 
      ** Prior to validation, initialise error indicators as 'OK'
 
     C                   EXSR      SRRESETERR
 
      ** Reset yield rate valid file
 
     C                   CLEAR                   ValidYRDets
 
      ** Validate key fields and retrieve record for action
      ** 'A', 'D', or 'E'.
 
     C                   EXSR      SRRTVREC
 
      ** If error found on action code or key fields, display message
 
     C                   IF        (OKACTN = 'N') OR (OKYLDC = 'N') OR
     C                             (OKYCCY = 'N') OR (OKYICM = 'N') OR
     C                             (OKYCFQ = 'N')
     C                             AND CAS008 = 'N'                                           CAS008
     C                             OR (OKACTN = 'N') AND (OKYLDC = 'N')                       CAS008
     C                             AND (OKYCCY = 'N') AND (OKYICM = 'N')                      CAS008
     C                             AND (OKYCFQ = 'N') AND (OKSPDY = 'N')                      CAS008
     C                             AND CAS008 = 'Y'                                           CAS008
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Save previous yield rates details
 
     C                   IF        (#0ACTN <> 'I')
     C                   IF        (#0ACTN <> P_#0ACTN) OR (#0YLDC <> P_#0YLDC)
     C                             OR (#0YCCY <> P_#0YCCY)
     C                             OR (#0YICM <> P_#0YICM)
     C                   EVAL      PrvYRFilFmt = CrYRFilFmt
     C                   ENDIF
     C                   ENDIF
 
      ** Put yield rates details to screen fields when one of the following
      ** conditions is true:
      ** 1.) First time to pass to CONVERSION module and action taken is
      **     'E', 'A', or 'D'
      ** 2.) The action code has been changed
      ** 3.) The key fields have been changed
      ** 4.) Enquire mode and there has been a change in the rate details when
      **     input fields are input capable
      ** 5.) Delete mode and there has been a change in the rate details when
      **     input fields are input capable
 
     C                   IF        (#0ACTN = 'E') OR (#0ACTN = 'D') OR
     C                             (#0ACTN = 'A')
 
     C                   IF        (#0ACTN <> P_#0ACTN) OR (#0YLDC <> P_#0YLDC)
     C                             OR (#0YCCY <> P_#0YCCY)
     C                             OR (#0YICM <> P_#0YICM)
     C                             OR (#0ACTN = 'E') AND
     C                             (PrvYRScnFmt <> CurYRScnFmt) OR
     C                             (#0ACTN = 'D') AND
     C                             (PrvYRScnFmt <> CurYRScnFmt)
     C                   EVAL      WPRVCONV = 'N'
     C                   ENDIF
 
      ** Convert to screen format
 
     C                   IF        (WPRVCONV = 'N')
     C                   EXSR      SRCONVERT
     C                   ENDIF
     C                   ENDIF
 
      ** For action 'E' or 'D' if the previous screen is the same as
      ** the current screen, go to initial screen
 
     C                   IF        (WriteOnly = 'Y') AND (#0ACTN = 'E') OR
     C                             (WriteOnly = 'Y') AND (#0ACTN = 'D')
     C                   IF        (PrvYRScnFmt = CurYRScnFmt)
     C/COPY WNCPYSRC,SDYRATSC03
     C                   CLEAR                   CurYRScnFmt
     C                   MOVEA     *BLANKS       PMatAr
     C                   MOVEA     *BLANKS       PDFcAr
     C                   EXSR      SRRESETERR
     C                   GOTO      ENDVAL
     C                   ENDIF
     C                   ENDIF
 
      ** Validate detail inputs for Amend or Insert
 
     C                   IF        (#0ACTN = 'I') OR (#0ACTN = 'A')
     C                   CALLB     'SDYRATVAL'
     C                   PARM                    RespMode
     C                   PARM      *BLANK        PModeOfOp
     C                   PARM                    CurYRScnFmt
     C                   PARM                    CurYRExtDta
     C                   PARM                    PrvYRFilFmt
     C                   PARM                    OKYRDets
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIDAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIDAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    WIdx
     C                   PARM      *BLANKS       PMatAr
     C                   PARM                    ValidYRDets
 
      ** Errors returned
 
     C                   IF        Idx <> *ZERO
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** If the screen has changed in the course of the validation
      ** or there are warnings which have not been displayed,
      ** re-output the screen
 
     C                   EVAL      WIdx_PVal = WIdx_PVal + WIdx
     C                   IF        (CurYRScnFmt <> PrvYRScnFmt) OR
     C                             (WIdx_PVal <> PrvN_Warn)
     C                   GOTO      ENDVAL
     C                   ENDIF
 
      ** Clear any warning messages
 
     C                   EVAL      OKYRDets = *ALL'Y'
     C                   EVAL      WFldNamAr2 = *BLANK
     C                   EVAL      WMsgIdAr2 = *BLANK
     C                   EVAL      WMsgDtaAr2 = *BLANK
 
      ** Confirm inputs
 
     C**********         IF        (%SUBST(CurYRScnFmt:12) <> *BLANK) AND                     CAS008
     C                   IF        (%SUBST(CurYRScnFmt:14) <> *BLANK) AND                     CAS008
     C                             (#0ACTN = P_#0ACTN) AND (#0YLDC = P_#0YLDC)
     C                             AND (#0YCCY = P_#0YCCY)
     C                             AND (#0YICM = P_#0YICM)
     C                   EVAL      W@SCRN = 'C'
     C/COPY WNCPYSRC,SDYRATSC04
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,SDYRATSC05
 
     C     ENDVAL        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRTVREC    - Retrieve Yield Rates Details                    *
      *                                                               *
      * Called By : SRROLL, SRRDNXTB and SRVALIDATE subroutines       *
      *                                                               *
      * Calls :                                                       *
      * SDYRATRTV   - Yield Rate Retrieve Module                      *
      *                                                               *
      *****************************************************************
 
     C     SRRTVREC      BEGSR
 
      ** Call Retrieve Module
 
     C
     C                   IF        #0YLDC = WkPrvYLC AND #0YCCY = WkPrvCCY AND
     C                             #0YICM = WkPrvICM AND #0ACTN = WkPrvACT AND
     C                             #0ACTN = 'A'
     C                   EVAL      PKYCFQ = 'N'
     C                   ENDIF
     C
     C                   CALLB     'SDYRATRTV'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      *BLANK        PModeOfOp
     C                   PARM                    RespMode
     C                   PARM                    #0ACTN
     C                   PARM                    #0YLDC
     C                   PARM                    #0YCCY
     C                   PARM                    #0YICM
     C                   PARM                    #0YCFQ
     C                   PARM                    #0SPDY                                       CAS008
     C                   PARM                    PFOTRID
     C                   PARM      *BLANK        CrYRFilFmt
     C                   PARM                    OKACTN
     C                   PARM                    OKYLDC
     C                   PARM                    OKYCCY
     C                   PARM                    OKYICM
     C                   PARM                    OKYCFQ
     C                   PARM                    OKSPDY                                       CAS008
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIdAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    Idx
     C                   PARM                    PKYCFQ
 
      ** store retrieved values
 
     C                   EVAL      PKYCFQ = 'Y'
     C                   EVAL      WkPrvCFQ = #0YCFQ
     C                   EVAL      WkPrvACT = #0ACTN
     C                   EVAL      WkPrvYLC = #0YLDC
     C                   EVAL      WkPrvCCY = #0YCCY
     C                   EVAL      WkPrvICM = #0YICM
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONVERT   - Convert Yield Rates Details in Screen Format    *
      *                                                               *
      * Called By : SRROLL, SRRDNXTB and SRVALIDATE subroutines       *
      *                                                               *
      * Calls :                                                       *
      * SDYRATCVT   - Yield Rate Convert Module                       *
      *                                                               *
      *****************************************************************
 
     C     SRCONVERT     BEGSR
 
      ** Call Convert Module
 
     C                   CALLB     'SDYRATCVT'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    CrYRFilFmt
     C                   PARM                    CurYRScnFmt
     C                   PARM      *BLANKS       PMatAr
     C                   PARM      *BLANKS       PDFcAr
 
     C                   EVAL      WPRVCONV = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCONFIRM   - Confirm Screen Inputs                           *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SDYRATDSP   - Yield Rate Display Module                       *
      * SRRESETERR  - Reset error fields                              *
      * SREND       - Program Termination                             *
      * SRCANCEL    - Cancel Screen Inputs                            *
      * SREXITC     - Exit Confirmation Screen                        *
      *                                                               *
      *****************************************************************
 
     C     SRCONFIRM     BEGSR
 
      ** If transaction is valid output message 'Press enter to accept'
 
     C                   IF        Idx = *ZERO
     C                   EVAL      FldNameAr2(1) = '*ANY'
     C                   EVAL      MsgIdAr2(1) = 'USR9219'
     C                   ENDIF
 
     C                   CALLB     'SDYRATDSP'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CurYRScnFmt
     C                   PARM                    PMatAr
     C                   PARM                    PDFcAr
     C                   PARM                    FldNameAr2
     C                   PARM                    MsgIdAr2
     C                   PARM                    MsgDtaAr2
     C                   PARM                    WFldNamAr2
     C                   PARM                    WMsgIdAr2
     C                   PARM                    WMsgDtaAr2
     C                   PARM                    OKYRDets
     C                   PARM      'N'           PEKYFD
     C                   PARM      'Y'           WriteOnly
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
     C                   PARM      FALSE         PINKC
     C                   PARM      FALSE         PINKG
     C                   PARM      FALSE         PINKH
     C                   PARM      FALSE         PINKJ
     C                   PARM      FALSE         PINKL
     C                   PARM      FALSE         PINKP
 
      ** Reset Error fields
 
     C                   EXSR      SRRESETERR
 
      ** Process function keys
 
     C     PINKC         CASEQ     TRUE          SREND
     C     PINKL         CASEQ     TRUE          SRCANCEL
     C                   CAS                     SREXITC
     C                   ENDCS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPDATE    -  Update Database                                *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * SDYRATUPD   - Yield Rate Update Module                        *
      * *PSSR       - DB Error Processing                             *
      *                                                               *
      *****************************************************************
 
     C     SRUPDATE      BEGSR
 
      ** Call update module
 
     C                   CALLB     'SDYRATUPD'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    ValidYRDets
     C/COPY WNCPYSRC,SDYRATSC06
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program. Otherwise, commit the updates
 
     C                   IF        (RetCodeOut <> *BLANK) AND
     C                             (RetCodeOut <> '*RECUPD')
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
      ** If update not done due to record being updated by another
      ** workstation send message to screen.
 
     C                   IF        RetCodeOut = '*RECUPD'
     C                   EVAL      FldNameAr2(1) = '*ANY'
     C                   EVAL      MsgIdAr2(1) = 'USR9220'
     C                   ENDIF
 
      ** If successful update, send message to screen
 
     C                   IF        RetCodeOut = *BLANK
     C                   IF        #0ACTN = 'D'
     C                   EVAL      MsgIdAr2(1) = 'USR9221'
     C                   ELSE
     C                   IF        #0ACTN = 'A'
     C                   EVAL      MsgIdAr2(1) = 'USR9222'
     C                   ELSE
     C                   EVAL      MsgIdAr2(1) = 'USR9223'
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      FldNameAr2(1) = '*ANY'
     C                   EVAL      MsgDtaAr2(1) = #0YLDC + #0YCCY + #0YICM
     C                   ENDIF
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRDNXTB = 'Y'
     C                   EVAL      W@SCRN = 'R'
     C                   ELSE
 
      ** Else, go to initial screen
 
     C                   CLEAR                   CurYRScnFmt
     C                   MOVEA     *BLANKS       PMatAr
     C                   MOVEA     *BLANKS       PDFcAr
 
     C                   EVAL      W@SCRN = 'I'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDELETE    -  Delete Record                                  *
      *                                                               *
      * Called By : SRDSPINI subroutine                               *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRDELETE      BEGSR
 
      ** F10 taken, go on to updates
 
     C                   EVAL      ValidYRDets = CrYRFilFmt
     C                   EVAL      FSRECI = 'C'
     C                   EVAL      FSCHTP = #0ACTN
     C                   EVAL      W@SCRN = 'U'
     C/COPY WNCPYSRC,SDYRATSC07
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREXITC     - Exit Confirmation Screen                        *
      *                                                               *
      * Called By : SRCONFIRM subroutine                              *
      *                                                               *
      * Calls :                                                       *
      * SRSETFSTS   - Set Field Status                                *
      *                                                               *
      *****************************************************************
 
     C     SREXITC       BEGSR
 
      ** No errors in validation, continue with updates
 
     C                   IF        Idx = *ZERO
     C                   EVAL      W@SCRN = 'U'
     C                   ELSE
 
      ** Go back to initial screen
 
     C                   EVAL      W@SCRN = 'I'
     C                   EXSR      SRSETFSTS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSETFSTS   - Set Field Status                                *
      *                                                               *
      * Called By : SRDSPINI and SREXITC subroutines                  *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSETFSTS     BEGSR
 
      ** According to action code, set WriteOnly indicator
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKJ = 'Y'
     C                   EVAL      PEINKP = 'Y'
 
     C                   SELECT
 
      ** Fields that are input capable
 
     C                   WHEN      (#0ACTN = 'I') OR (#0ACTN = 'A')
     C                   EVAL      WriteOnly = 'N'
     C                   EVAL      PEINKJ = 'N'
 
      ** Fields that are not capable for input
 
     C                   WHEN      (#0ACTN = 'E') OR (#0ACTN = 'D')
 
      ** Make fields available for input when cancel has been pressed
      ** from the initial screen or an error has been sent
 
     C                   IF        WBRWCA <> 'Y'
     C                   IF        (WINICA = 'Y') OR
     C                             (PERRMS <> *BLANK) OR (Idx <> *ZERO)
     C                   EVAL      WriteOnly = 'N'
     C                   ELSE
     C                   EVAL      WriteOnly = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0ACTN = 'D'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
 
     C                   OTHER
     C                   EVAL      WriteOnly = 'N'
     C                   EVAL      PEINKJ = 'N'
     C                   ENDSL
 
      ** Initialise cancel workfields (Cancels taken on Browse or Initial Screen)
 
     C                   EVAL      WINICA = 'N'
     C                   EVAL      WBRWCA = 'N'
 
      ** Set status of key fields
 
     C     WriteOnly     IFEQ      'Y'
     C                   EVAL      PEKYFD = 'N'
     C                   ELSE
     C                   EVAL      PEKYFD = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRESETERR  - Reset error fields                              *
      *                                                               *
      * Called By : SRDSPINI, SRVALIDATE, SRCONFIRM and SRCANCEL      *
      *             subroutines                                       *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRRESETERR    BEGSR
 
      ** Reset error fields
 
     C                   RESET                   FldNameAr2
     C                   RESET                   MsgIDAr2
     C                   RESET                   MsgDtaAr2
     C                   RESET                   Idx
 
      ** Reset warning fields
 
     C                   RESET                   WFldNamAr2
     C                   RESET                   WMsgIdAr2
     C                   RESET                   WMsgDtaAr2
     C                   RESET                   WIdx
 
      ** Reset OK flags
 
     C                   EVAL      OKYRDets = *ALL'Y'
 
     C                   EVAL      PERRMS = *BLANK
 
      ** Reset Warning workfield
 
     C                   EVAL      WIdx_PVAL = *ZERO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSNDERR    - Send Error Messages from the called Module      *
      *                                                               *
      * Called By : SRROLL, SRBROWSE and SRRDNXTB subroutines         *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRSNDERR      BEGSR
 
      ** Action code is invalid or invalid for user
 
     C                   IF        (PERRMS = 'USR9248') OR (PERRMS = 'USR9194')
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
 
      ** Add error message to array passed to input screen
 
     C                   Z-ADD     1             A                 3 0
     C     *BLANK        LOOKUP    FldNameAr2(A)                          99
     C                   EVAL      FldNameAr2(A) = '*ANY'
     C                   EVAL      MsgIdAr2(A) = PERRMS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREND       - Program Termination                             *
      *                                                               *
      * Called By : SRDSPINI, SRBROWSE and SRCONFIRM                  *
      *                                                               *
      * Calls : None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SREND         BEGSR
 
     C                   EVAL      W@SCRN = 'T'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCANCEL    - Cancel Screen Inputs                            *
      *                                                               *
      * Called By : SRDSPINI, SRBROWSE and SRCONFIRM                  *
      *                                                               *
      * Calls :                                                       *
      * SRRESETERR  - Reset error fields                              *
      *                                                               *
      *****************************************************************
 
     C     SRCANCEL      BEGSR
 
      ** Cancel is not taken from confirm, initialise previous variables
 
     C                   IF        W@SCRN <> 'C'
     C                   EVAL      WkPrvACT = *BLANKS
     C                   EVAL      WkPrvYLC = *BLANKS
     C                   EVAL      WkPrvCCY = *BLANKS
     C                   EVAL      WkPrvICM = *BLANKS
     C                   EVAL      WkPrvCFQ = *BLANKS
     C                   ENDIF
 
      ** If input fields are enabled, blank screens
 
     C                   IF        W@SCRN = 'I'
     C                   IF        (WriteOnly = 'N') AND (PINKP = FALSE)
     C                   CLEAR                   CurYRScnFmt
     C                   MOVEA     *BLANKS       PMatAr
     C                   MOVEA     *BLANKS       PDFcAr
 
      ** Reset read next browse indicator
 
     C                   EVAL      WRDNXTB = *BLANK
     C                   ENDIF
 
      ** Cancel taken from browse, otherwise taken on initial screen
 
     C                   IF        PINKP = TRUE
     C                   EVAL      WBRWCA  = 'Y'
     C                   ELSE
     C                   EVAL      WINICA  = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** Reset error fields
 
     C                   EXSR      SRRESETERR
 
     C                   EVAL      W@SCRN = 'I'
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR     - Program Initialisation                          *
      *             - This subroutine runs automatically for program  *
      *              initialisation.                                  *
      *                                                               *
      * Called By : Main Processing                                   *
      *                                                               *
      * Calls :                                                       *
      * AOBANKR0    - Bank Details Access Object                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZERO
     C                   EVAL      DBFILE = *BLANK
     C                   EVAL      DBKEY = *BLANK
     C                   OUT       LDA
 
      ** Initialise Data Structures and work variables
 
     C                   CLEAR                   CurYRScnFmt
     C                   MOVEA     *BLANKS       PMatAr
     C                   MOVEA     *BLANKS       PDFcAr
     C                   CLEAR                   CrYRFilFmt
     C                   CLEAR                   PrvYRScnFmt
     C                   CLEAR                   ValidYRDets
 
     C                   EVAL      WkPrvACT = *BLANKS
     C                   EVAL      WkPrvYLC = *BLANKS
     C                   EVAL      WkPrvCCY = *BLANKS
     C                   EVAL      WkPrvICM = *BLANKS
     C                   EVAL      WkPrvCFQ = *BLANKS
     C                   EVAL      PKYCFQ = 'Y'
 
      ** Initialise read next browse workfield
 
     C                   EVAL      WRDNXTB = *BLANK
 
      ** Set screen to initial screen
 
     C                   EVAL      W@SCRN = 'I'
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
      ** Access bank detail
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD  <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = POPTN
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,SDYRATSC08
      *                                                                                       CAS008
      ** Check if switchable feature CAS008 is switched on                                    CAS008
      *                                                                                       CAS008
     C                   CALLB     'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRtCd                                        CAS008
     C                   PARM      '*VERIFY '    POptn                                        CAS008
     C                   PARM      'CAS008'      PSard                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   IF        PRtCd <> *BLANKS AND                                       CAS008
     C                             PRtCd <> '*NRF'                                            CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY = 'CAS008'                                           CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE = 2                                                  CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ELSE                                                                 CAS008
     C                   IF        PRtCd = *BLANKS                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,SDYRATSC09
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
