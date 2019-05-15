     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Account Review Detail Convert')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDACRVCVT - Account Review Conversion: File to Screen        *
      *              Format                                           *
      *                                                               *
      *  Function:  This module converts the fields of a SDACRVPD     *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD092  *CREATE    Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      /COPY ZACPYSRC,STD_D_SPEC
 
      /COPY ZACPYSRC,STDDECLARE
 
      /COPY ZACPYSRC,PSDS
 
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
 
      ** SDACRVPD Transaction Details in File Format
     D TranFilFmt    E DS                  EXTNAME(SDACRVPD)
 
      ** SDACRVPD Transaction Details in Screen Format
     D TrnDets       E DS                  EXTNAME(SDACRFPD)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D WFTMST          DS
     D  WWHH                   1      2
     D  WWMM                   3      4
     D  WWSS                   5      6
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** Parameter for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** Other Variables
     D ##ACTN          S              1A
     D WWTMST          S              6A
     D WWDFIN          S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Set screen fields
 
     C                   EXSR      SRScreen
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScreen - Set Screen Fields                                 *
      *                                                               *
      *  Called by: Main Routine                                      *
      *                                                               *
      *  Calls    : SRZDate2                                          *
      *                                                               *
      *****************************************************************
 
     C     SRScreen      BEGSR
 
      ** Customer Number
     C                   EVAL      DDCUST = ARCUST
 
      ** Account Review Sequence
     C                   MOVE      *BLANKS       DDSEQN
     C                   MOVE      ARSEQN        DDSEQN
 
      ** Account Review Purpose
     C                   EVAL      DDPUR1 = %SUBST(ARPURP:1:64)
     C                   EVAL      DDPUR2 = %SUBST(ARPURP:65:64)
     C                   EVAL      DDPUR3 = %SUBST(ARPURP:129:64)
     C                   EVAL      DDPUR4 = %SUBST(ARPURP:193:63)
 
      ** Account Review Actual Date
     C                   IF        ARACDT <> 0
     C                   EVAL      ZDAYNO = ARACDT
     C                   EXSR      SRZDate2
     C                   EVAL      DDACDF = *ZERO
     C                   MOVEL     ZDATE         DDACDF
     C                   ENDIF
 
      ** Account Review Actual Time
     C                   EVAL      WFTMST = ARACTM
     C                   EVAL      DDACTM = *BLANKS
     C                   IF        WFTMST <> *BLANKS
     C                   EVAL      DDACTM = WWHH + ':' + WWMM +
     C                                      ':' + WWSS
     C                   ENDIF
 
      ** Account Review Scheduled Date
     C                   IF        ARSCDT <> 0
     C                   EVAL      ZDAYNO = ARSCDT
     C                   EXSR      SRZDate2
     C                   EVAL      DDSCDF = *BLANKS
     C                   MOVEL     ZDATE         DDSCDF
     C                   ENDIF
 
      ** Account Review Comment
     C                   EVAL      DDCOM1 = %SUBST(ARCOMM:1:64)
     C                   EVAL      DDCOM2 = %SUBST(ARCOMM:65:64)
     C                   EVAL      DDCOM3 = %SUBST(ARCOMM:129:64)
     C                   EVAL      DDCOM4 = %SUBST(ARCOMM:193:64)
 
      ** Account Review Comment - User name
     C                   EVAL      DDCMSR = ARCUSC
 
      ** Account Review Comment - Date
     C                   IF        ARCDAC <> 0
     C                   EVAL      ZDAYNO = ARCDAC
     C                   EXSR      SRZDate2
     C                   EVAL      DDCMAF = *BLANKS
     C                   MOVEL     ZDATE         DDCMAF
     C                   ENDIF
 
      ** Account Review Comment - Time
     C                   EVAL      WFTMST = ARCTIC
     C                   EVAL      DDCMIM = *BLANKS
     C                   IF        WFTMST <> *BLANKS
     C                   EVAL      DDCMIM = WWHH + ':' + WWMM +
     C                                      ':' + WWSS
     C                   ENDIF
 
      ** Account Review Frequency
     C                   EVAL      DDACRF = ARACRF
 
      ** Account Review Next Schedule Date
     C                   IF        ARNSDT <> 0
     C                   EVAL      ZDAYNO = ARNSDT
     C                   EXSR      SRZDate2
     C                   EVAL      DDNSDF = *BLANKS
     C                   MOVEL     ZDATE         DDNSDF
     C                   ENDIF
 
      ** Account Review Complete Flag
     C                   EVAL      DDCOMP = ARCOMP
 
      ** Account Review Completion - User name
     C                   EVAL      DDCUSR = ARCUSR
 
      ** Account Review Completion - Date
     C                   IF        ARCDAT <> 0
     C                   EVAL      ZDAYNO = ARCDAT
     C                   EXSR      SRZDate2
     C                   EVAL      DDCDAF = *BLANKS
     C                   MOVEL     ZDATE         DDCDAF
     C                   ENDIF
 
      ** Account Review Completion - Time
     C                   EVAL      WFTMST = ARCTIM
     C                   EVAL      DDCTIM = *BLANKS
     C                   IF        WFTMST <> *BLANKS
     C                   EVAL      DDCTIM = WWHH + ':' + WWMM +
     C                                      ':' + WWSS
     C                   ENDIF
 
      ** Account Review Manual or Generated
     C                   EVAL      DDMAGE = ARMAGE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Format a date for output                          *
      *                                                               *
      *  Called by: SRScreen                                          *
      *                                                               *
      *  Calls    : ZDATE2                                            *
      *                                                               *
      *****************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   EVAL      WWDFIN = BJDFIN
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    WWDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialization                                      *
      *                                                               *
      *  Called by: SRInit                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Blank outputs (Except for Action Code)
 
     C                   EVAL      ##ACTN = DDACTN
     C                   EVAL      TrnDets = *Blanks
     C                   EVAL      DDACTN = ##ACTN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** SDACRVPD Transaction Details File Format
     C                   PARM                    TranFilFmt
 
      ** Output Parameters
      ** SDACRVPD Transaction Details Screen Format
     C                   PARM                    TrnDets
 
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACRVCVT'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CTDATA CPY@
(c) Finastra International Limited 2014
