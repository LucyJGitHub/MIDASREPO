     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2012')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('DL Adjustment Accrued Interest Details Validation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DLDLAAVAL - Midas DL Transactions Details Validation         *
      *                                                               *
      *  (c) Finastra International Limited 2012                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1096788          Date 18Mar13               *
      *                 CAP210  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1096788 - DLAA details should be written in core STRANF    *
      *              file instead of the new DLSTRANFPD file          *
      *  CAP210 - Adjustment to Accrued Interests API                 *
      *                                                               *
      *****************************************************************
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
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
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
      ** Data Structure for Zalign
0082 D ZA1             S              1    DIM(16)
0083 D ZA2             S              1    DIM(16)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Transaction Details in screen format
     D TrnDets       E DS                  EXTNAME(DLDLAAPD)
      ** Transaction Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(DLEDLAAPD)
      ** Valid Transaction Details layout In File Format
     D ValidDLAA     E DS                  EXTNAME(DLVDLAAPD)
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Short DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Data structure for currency details
     D @CURR         E DS                  EXTNAME(SDCURRPD)
      *
     D ZMUSER          DS            17
     D  USRBCH                11     13
      *
      ** Work fields for bank data
     D WKDFIN          S                   LIKE(BJDFIN)
     D WKRDNB          S                   LIKE(BJRDNB)
     D WKCYCD          S                   LIKE(BJCYCD)
     D BLK16           S                   LIKE(ZFIELD)
     D DSBrcTyp        S              5A                                                   AR1096788
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Start of Main Processing
      *
     C                   EXSR      VLDLAA
      *
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VLDLAA
      *****************************************************************
     C     VLDLAA        BEGSR
      ** Reset variables updated by validation
     C                   EXSR      RESETERRS
      *
     C                   CALLB     'DLVDLAA'
      *
      ** Inputs
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** fields to be validated
      *
     C                   PARM                    TrnDets
      *
      ** Outputs
      *
     C                   PARM                    DSBrcTyp                                  AR1096788
      ** Fields validation flags
     C                   PARM                    OkTrnDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      ** Update error info with that returned from the validation module
     C                   EXSR      UPDATERRS
      ** Set Transaction fields for valid records
     C                   EVAL      VFTYLC = DDACTN
     C                   MOVEL     DDDLNO        VFDLNO
     C                   MOVEL     DDCNUM        VFCNUM
     C                   EVAL      VFCCY  = DDCCY
      ** Call Access Pgm For Currency Details
     C                   IF        DDCCYOK  = 'Y'
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      VFCCY         @AJCD             3
     C     @CURR         PARM      @CURR         DSSDY
     C                   ENDIF
      **  Align input amounts
     C                   IF        DDMAAMOK = 'Y'
     C                   Z-ADD     A6NBDP        ZADEC
0544 C                   MOVEL     BLK16         ZFIELD
0545 C                   MOVE      DDMAAM        ZFIELD
0546 C                   Z-ADD     13            ZADIG
0578 C                   SUB       A6NBDP        ZADIG
      *
0548 C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        VFMAAM
     C                   ENDIF
      *
     C                   IF        DDUSITOK = 'Y'
     C                   Z-ADD     A6NBDP        ZADEC
0544 C                   MOVEL     BLK16         ZFIELD
0545 C                   MOVE      DDUSIT        ZFIELD
0546 C                   Z-ADD     13            ZADIG
0578 C                   SUB       A6NBDP        ZADIG
      *
0548 C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        VFUSIT
     C                   ENDIF
      *
     C                   IF        DDAACFOK = 'Y'
     C                   Z-ADD     A6NBDP        ZADEC
0544 C                   MOVEL     BLK16         ZFIELD
0545 C                   MOVE      DDAACF        ZFIELD
0546 C                   Z-ADD     13            ZADIG
0578 C                   SUB       A6NBDP        ZADIG
      *
0548 C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        VFAACF
     C                   ENDIF
      *
     C                   EVAL      VFSIGN = DDSIGN
     C                   EVAL      VFINIRS = DDINIRS
     C                   EVAL      VFFSGN = DDFSGN
     C                   MOVEL     DSBrcTyp      VFBRCA                                    AR1096788
     C                   MOVE      DSBrcTyp      VFDTYP                                    AR1096788
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *Blanks
      ** Reset error & warning fields/message IDs/message data (arrays)
     C                   EVAL      FldNamXAr = *BLANK
     C                   EVAL      MsgIDXAr  = *BLANK
     C                   EVAL      MsgDtaXAr = *BLANK
     C                   EVAL      WFldNmXAr = *BLANK
     C                   EVAL      WMsgIDXAr = *BLANK
     C                   EVAL      WMsgDtXAr = *BLANK
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ** Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ** Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C                   IF        *IN99 = *ON
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   ENDIF
      *
      ** Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     I             SUB       1             WIdx
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *inzsr        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Inputs
      *
      ** Response mode
      *
     C                   PARM                    RespMode          1
      ** Transaction Details
     C                   PARM                    TrnDets
      ** Outputs
      *
      ** Transaction Details OK inds
     C                   PARM                    OKTrnDets
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    ValidDLAA
      ** ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 900
     C                   EVAL      DBKEY  = @OPTN
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WKDFIN = BJDFIN
     C                   EVAL      WKRDNB = BJRDNB
     C                   EVAL      WKCYCD = BJCYCD
     C                   ENDIF
      *
      ** Check if switchable feature S01496 is switched on.
      ** Private Banking Securities Trading Enhancement
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS AND
     C                             @RTCD <> '*NRF   '
     C                   EVAL      DBKEY  = 'S01496'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE  =  902
     C                   EXSR      SRERR
     C                   ENDIF
     C                   IF        @RTCD = *BLANK
     C                   MOVE      'Y'           S01496            1
     C                   ELSE
     C                   MOVE      'N'           S01496
     C                   ENDIF
      *
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRERR - EXCEPTION ERRORS                                      *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
     C                   EVAL      DBPGM = 'DLDLAAVAL'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      **  Terminte the program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      **   ZALIGN SR. TO VALIDATE AND RIGHT-ALIGN NUMERIC FIELDS.
      *
     C     ZALIGN        BEGSR
      *
     C                   SETOFF                                       929399
      **   SAVE INPUT FIELD IN ARRAY, ZA1.
     C                   MOVEA     ZFIELD        ZA1
      *
      **   CALCULATION TO DEFINE NUMBER STRUCTURE CONTROL FIELDS.
      *
     C                   Z-ADD     ZADIG         ZADIG             2 0
     C                   Z-ADD     ZADEC         ZADEC             1 0
      *
      **   CALCULATIONS TO DEFINE/CLEAR FIELDS.
      *
     C                   MOVE      ' '           ZA2
     C                   MOVEA     ZA2           ZFIELD           16
     C                   Z-ADD     0             ZX                2 0
     C                   Z-ADD     0             ZY                2 0
      *
      **   ENSURE REQUIRED STRUCTURE OF FIELD IS VALID.
      *
     C     ZADIG         ADD       ZADEC         ZZ                2 0
     C     ZZ            COMP      15                                 99
     C   99              GOTO      ZAEND
      *
      **   LOOP TO FIND DECIMAL POINT, BLANKS AND CHARACTERS.
      *
     C     ZATAG1        TAG
     C     ZX            ADD       1             ZX
      *
      **   CHECK FOR DECIMAL POINT. ERROR IF SECOND DECIMAL POINT.
      *
     C     ZA1(ZX)       COMP      '.'                                    90
     C   90
     CAN 93              SETON                                        99
     C   99              GOTO      ZAEND
      **   CHECK FOR 'M' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'M'                                    96
     C   96              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      9                                  99
     C   99              GOTO      ZAEND
     C                   END
      **   CHECK FOR 'T' CONSTANT. ERROR IF NOT LAST CHARACTER ENTERED
     C     ZA1(ZX)       COMP      'T'                                    97
     C   97              DO
     C     ZX            COMP      15                                 99  99
     C   99              GOTO      ZAEND
     C     ZX            ADD       1             ZX
     C     ZA1(ZX)       COMP      ' '                                9999
     C   99              GOTO      ZAEND
     C     ZX            SUB       1             ZX
     C     ZX            COMP      12                                 99
     C   99              GOTO      ZAEND
     C                   END
      **   CLEAR ALPHAMERIC CONSTANT FROM ZA1
     C   96
     COR 97              MOVE      ' '           ZA1(ZX)
      **   CHECK FOR BLANKS. BYPASS FOR FIRST BLANK AFTER A DIGIT.
     C     ZA1(ZX)       COMP      ' '                                    91
     C   91
     CAN 92              GOTO      ZATAG2
      **   CHECK FOR NUMERIC, IF NOT '.' OR ' '.
     C  N90
     CANN91ZA1(ZX)       COMP      '0'                                  99
     C  N90
     CANN91
     CANN99ZA1(ZX)       COMP      '9'                                99
     C   99              GOTO      ZAEND
      **   STORE DIGITS IN ARRAY AND HOW MANY.
      **   ZY, TOTAL OF DIGITS IN THE INPUT FIELD.
      **   ZZ, TOTAL OF DIGITS TO THE LEFT OF DECIMAL POINT.
     C  N90
     CANN91ZY            ADD       1             ZY                   92
     C  N90
     CANN91              MOVE      ZA1(ZX)       ZA2(ZY)
     C   90              Z-ADD     ZY            ZZ                   93  93
      *
     C     ZX            COMP      16                                   94
     C   94              GOTO      ZATAG1
      *
     C     ZATAG2        TAG
      **   IF 'M' SPECIFIED, MULTIPLY ZA1 BY 1 MILLION
     C   96ZZ            ADD       6             ZZ
      **   IF 'T' SPECIFIED, MULTIPLY ZA1 BY 1 THOUSAND
     C   97ZZ            ADD       3             ZZ
      **   FILL IN ZEROS IN ANY BLANKS LEFT OF DECIMAL POINT
     C   96
     CAN 93
     COR 97
     CAN 93ZZ            DOWGT     ZY
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      **   IF CONSTANT SPECIFIED WITH NO DECIMAL POINT ZEROISE BLANKS
     C   96
     CANN93              DO        6
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      *
     C   97
     CANN93              DO        3
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C                   END
      **   IF NO DECIMAL POINT FOUND, SET TOTAL FIELD ZZ.
     C  N93              Z-ADD     ZY            ZZ
      **   CHECK FOR EMBEDDED BLANKS.
     C   91
     CAN 92              MOVEA     ZA1(ZX)       ZFIELD
     C   91
     CAN 92ZFIELD        COMP      ' '                                9999
     C   99              GOTO      ZAEND
      **   ENSURE THAT NUMBER OF DIGITS ENTERED EITHER SIDE
      **   OF DECIMAL POINT ARE NOT MORE THAN ALLOWED.
     C     ZZ            COMP      ZADIG                              99
     C     ZY            SUB       ZZ            ZX
     C  N99ZADEC         SUB       ZX            ZX                     9995
     C   99              GOTO      ZAEND
     C   95              GOTO      ZATAG4
      **   FILL THE TRAILING BLANKS WITH ZEROS.
     C     ZY            ADD       ZX            ZZ
     C     ZATAG3        TAG
     C     ZY            ADD       1             ZY
     C                   MOVE      '0'           ZA2(ZY)
     C     ZY            COMP      ZZ                                   94
     C   94              GOTO      ZATAG3
      **   RIGHT-ALIGN THE VALUE BY MOVING BACK TO ARRAY, ZA1.
     C     ZATAG4        TAG
     C                   MOVE      '0'           ZA1
     C                   Z-ADD     16            ZX
     C     ZATAG5        TAG
     C     ZY            COMP      0                                      94
     C   94              GOTO      ZATAG6
     C                   MOVE      ZA2(ZY)       ZA1(ZX)
     C     ZY            SUB       1             ZY
     C     ZX            SUB       1             ZX
     C                   GOTO      ZATAG5
     C     ZATAG6        TAG
      **   MOVE VALIDATED AND RIGHT-ALIGNED NUMBER BACK INTO ZFIELD.
     C                   MOVEA     ZA1           ZFIELD
      *
     C                   SETOFF                                       9697
      *
     C     ZAEND         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      **---------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **---------------------------------------------------------------
      *****************************************************************
