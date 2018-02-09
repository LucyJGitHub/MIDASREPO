     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Nostro Transfer Validate Inter Banks')        *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVINTB - Midas FT Nostro Transfer Validate Intermediary     *
      *            Banks                                              *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP212  *CREATE    Date 15Sep14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP212 - FT Nostro Transfer API                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** Transfer Details in screen format
     D TrnDets       E DS                  EXTNAME(FTFTNTPD)
     D  InterBanks            63    309
     D  InterBanks25         170    309
 
      ** Transfer Details OK indicators
     D OKTrnDets     E DS                  EXTNAME(FTEFTNTPD)
 
      ** Valid Transfer Details layout
     D ValidNoTr     E DS                  EXTNAME(FTVFTNTPD)
     D  ValidBanks           406    580
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** External DS for BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
 
      ** Long DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D/COPY FTCPYSRC,SFTADDRILE
     D/COPY FTCPYSRC,SFTVALCSLL
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D PRTCD           S              7
     D POPTN           S              7
     D PCNUM           S             10
     D PKYST           S              7
     D ##CSID          S              1
     D ADSLON          S              1
     D WCUST           S              1
     D WIntBanks       S            175
     D CLSWTK          S             12
     D ADLINE          S              1
     D ADFLDM          S              7
     D ADFLDF          S             10
 
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
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
 
      *
      ** VALIDATION
 
      ** If not entered, return.
     C                   IF        InterBanks = *BLANKS
     C                   GOTO      EMAIN
     C                   ENDIF
 
     C                   EVAL      WCUST = *BLANK
     C                   MOVEL     NTINT1        WIntBanks
     C                   MOVE      InterBanks25  WIntBanks
     C                   MOVEL(P)  WIntBanks     ADDRSS
 
      ** If first ten characters used, then check if a valid customer
     C                   IF        ADCH26 = *BLANKS AND                         B001
     C                             ADEXCS = *BLANKS AND
     C                             ADSLSH <> '/' OR
     C                             ADCH36 = *BLANKS AND
     C                             ADXCS2 = *BLANKS AND
     C                             ADCHK2 <> *BLANKS AND
     C                             ADSLSH = '/' AND
     C                             ADSLS2 <> '/'
      *
      *** First 10 characters should be key for SDCUST
     C                   IF        ADSLSH <> '/'
     C                   MOVEL     ADCHK1        PCNUM
     C                   ELSE
     C                   MOVEL     ADCHK2        PCNUM
     C                   ENDIF
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNUM
     C                   PARM      *BLANKS       PKYST
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      *** If not a valid customer, continue to SWIFT checking
     C                   IF        PRTCD <> *BLANKS                             B002
      *
     C                   EVAL      WCUST = 'Y'
     C                   GOTO      SWFTCHK
      *
     C                   ENDIF                                                  E002
      *
      *** Check that customer is a bank
     C                   IF        BBBNBI <> 'Y'                                B002
      *
     C                   ADD       1             Idx
     C                   IF        ADSLSH <> '/'
     C                   EVAL      OKINB1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT1    '
     C                   ELSE
     C                   EVAL      OKINB2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT2    '
     C                   ENDIF
     C                   EVAL      MsgIdXAr(Idx) = '5047451'
     C                   GOTO      EMAIN
      *
     C                   ENDIF                                                  E002
      *
      *** Overwrite shortname and move to valid field
     C                   IF        ADSLSH <> '/'
     C                   MOVEL(P)  BBCUST        NTINT1
     C                   ELSE
     C                   MOVEL(P)  BBCUST        NTINT2
     C                   ENDIF
     C                   EVAL      ValidBanks = WIntBanks
     C                   EVAL      NVINBT = 'C'
     C                   GOTO      EMAIN
      *
     C                   ENDIF                                                  E001
 
     C     SWFTCHK       TAG
      ** If first 11 characters used, then validate as a
      ** S.W.I.F.T. Address
     C                   IF        ADCH26 = *BLANKS AND                         B001
     C                             ADEXSW = *BLANKS AND
     C                             ADSLSH <> '/' OR
     C                             ADCH36 = *BLANKS AND
     C                             ADEXS2 = *BLANKS AND
     C                             ADSLSH = '/' AND
     C                             ADSLS2 <> '/'
      *
      *** First 11 characters should be key for CLSWT
     C                   IF        ADSLSH <> '/'
     C                   MOVEL     ADCHK1        CLSWTK
     C                   ELSE
     C                   MOVEL     ADCHK2        CLSWTK
     C                   ENDIF
      *
     C                   EXSR      SWIFT
      *
     C                   IF        ##CSID = 'Y'                                 B002
      *
     C                   IF        *IN31 = *ON                                  B003
     C                   ADD       1             Idx
     C                   IF        ADSLSH <> '/'
     C                   EVAL      OKINB1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT1    '
     C                   ELSE
     C                   EVAL      OKINB2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT2    '
     C                   ENDIF
     C                   EVAL      MsgIdXAr(Idx) = '5047452'
     C                   GOTO      EMAIN
     C                   ENDIF                                                  E003
      *
     C                   IF        *IN32 = *ON                                  B003
     C                   ADD       1             WIdx
     C                   IF        ADSLSH <> '/'
     C                   EVAL      WFldNmXAr(WIdx) = 'NTINT1    '
     C                   ELSE
     C                   EVAL      WFldNmXAr(WIdx) = 'NTINT2    '
     C                   ENDIF
     C                   EVAL      WMsgIdXAr(WIdx) = '5047453'
     C                   ENDIF                                                  E003
      *
     C                   EVAL      NVINBT = 'S'
     C                   EVAL      ValidBanks = WIntBanks
     C                   GOTO      EMAIN
      *
     C                   ENDIF                                                  E002
      *
     C                   ENDIF                                                  E001
 
      ** If not a valid customer, send error
     C                   IF        WCUST = 'Y'                                  B001
      *
     C                   ADD       1             Idx
     C                   IF        ADSLSH <> '/'
     C                   EVAL      OKINB1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT1    '
     C                   ELSE
     C                   EVAL      OKINB2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT2    '
     C                   ENDIF
     C                   EVAL      MsgIdXAr(Idx) = '5047450'
     C                   GOTO      EMAIN
      *
     C                   ENDIF                                                  E001
 
      ** Validate as an address
     C                   MOVE      'Y'           ADLINE
     C                   MOVEL     'FTM2319'     ADFLDM
     C                   MOVEL     'FTUSRMSG'    ADFLDF
     C                   EXSR      ADCHK
      *
     C                   IF        *IN91 = *ON                                  B001
     C                   ADD       1             Idx
     C                   EVAL      OKINB1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT1    '
     C                   EVAL      MsgIdXAr(Idx) = '5047454'
     C                   ENDIF                                                  E001
      *
     C                   IF        *IN92 = *ON                                  B001
     C                   ADD       1             Idx
     C                   EVAL      OKINB1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT1    '
     C                   EVAL      MsgIdXAr(Idx) = '5047455'
     C                   ENDIF                                                  E001
      *
     C                   IF        AD#1 = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      OKINB1 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT1    '
     C                   EVAL      MsgIdXAr(Idx) = '5047456'
     C                   ENDIF
      *
     C                   IF        AD#2 = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      OKINB2 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT2    '
     C                   EVAL      MsgIdXAr(Idx) = '5047456'
     C                   ENDIF
      *
     C                   IF        AD#3 = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      OKINB3 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT3    '
     C                   EVAL      MsgIdXAr(Idx) = '5047456'
     C                   ENDIF
      *
     C                   IF        AD#4 = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      OKINB4 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT4    '
     C                   EVAL      MsgIdXAr(Idx) = '5047456'
     C                   ENDIF
      *
     C                   IF        AD#5 = 'Y'
     C                   ADD       1             Idx
     C                   EVAL      OKINB5 = 'N'
     C                   EVAL      FldNamXAr(Idx) = 'NTINT5    '
     C                   EVAL      MsgIdXAr(Idx) = '5047456'
     C                   ENDIF
      *
      *** If no error found, tag as an address
     C                   IF        OKINB1 <> 'N' AND
     C                             OKINB2 <> 'N' AND
     C                             OKINB3 <> 'N' AND
     C                             OKINB4 <> 'N' AND
     C                             OKINB5 <> 'N'
     C                   EVAL      NVINBT = 'A'
     C                   EVAL      ValidBanks = WIntBanks
     C                   ENDIF
 
      * RETURN
 
     C     EMAIN         TAG
 
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** Screen Fields
     C                   PARM                    TrnDets
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      * OK Flags
     C                   PARM                    OKTrnDets
      *
      * Validation Fields
     C                   PARM                    ValidNoTr
 
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY FTCPYSRC,SFTADDRCLE
      ********************************************************************
     C/COPY FTCPYSRC,SFTADDRSC1
      ********************************************************************
     C/COPY FTCPYSRC,SFTSWFTCLE
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
