     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Account Review Frequency')           *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVARFR - Validate Account Review Frequency and Next         *
      *            Schedule Date                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD025689           Date 03Apr14               *
      *  Prev Amend No. MD027573A          Date 24Sep14               *
      *                 MD027573           Date 04Aug14               *
      *                 MD027575           Date 07Aug14               *
      *                 MD027572           Date 06Aug14               *
      *                 MD026207           Date 07Apr14               *
      *                 CSD092   *CREATE   Date 01May13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025689 - "Next schedule date does not match with account   *
      *             review frequency date" should be removed because  *
      *             it is not mentioned in FDS                        *
      *  MD027573A - Next schedule date must not be lower than        *
      *              rundate                                          *
      *  MD027573 - Next schedule date must not be lower than         *
      *             rundate                                           *
      *  MD027575 - No warning message displayed when next            *
      *             schedule date is set as a holiday                 *
      *  MD027572 - Account Review next scheduled date and sequence   *
      *             eventually becomes incorrect (Recompile)         *
      *  MD026207 - Mandatory fields are not highlighted after        *
      *             error validation                                  *
      *  CSD092 - Account Review                                      *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_XARRYS
 
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
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      ** Define work field Return code
     D W0RTN           S              7
      ** Define work field Work Screen Date
     D WUWSDT          S              6  0
      ** Define work field Date format flag
     D WUDFF           S              1
      ** Define work field Work File Date
     D WUWFDT          S              5  0
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids
     D WIx             S              3P 0
 
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)
     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)
     D ZHL             S              1    DIM(366)
     D ZHL1            S              1    DIM(366)
     D WDATE           S              6
     D DDNSDF          S              6
     D DDACRF          S              1
     D DDCOMP          S              1
     D WWDFIN          S              1
     D WWCYCD          S              3
     D WWLCCY          S              3
     D WWSLCD          S              3
     D DFSCDT          S              5P 0
     D DDSCDTOK        S              1
     D DDACRFOK        S              1
     D DDNSDTOK        S              1
     D DFACRF          S              1
     D DFNSDT          S              5P 0
     D WDCOMP          S              1
     D ZADATE          S              7
 
     D ZHOLDS          DS
 
      ** Data structure defined over holiday file fields
      ** Data structure has been copied from ZHOLILE
      ** and some definitions renamed due to naming conflicts
 
     D  DGCYCD                 1      3
     D  DGLCCD                 4      6
     D  DGYRNB                 7     10  0
     D  DGJDNB                11     13P 0
     D  DGDDNB                14     16P 0
     D  ZDS1                  17    202
     D  ZDS2                 203    382
     D  ZHL0                  17    382
 
     D ZVARS           DS
 
      ** Data structure to define variables used in holiday subroutines
 
     D  ZIND                   1      1
     D  ZINDX                  2      4  0
     D  ZDAYNO                 5      7P 0
     D  ZDYNBR                 8     10P 0
     D  ZNRDYS                11     12  0
     D  @ZWRDY                13     14  0
 
     D  ZCCY                  15     17
     D  ZLOC                  18     20
     D  @ZWRKI                15     20
 
     D  ZSCCY                 21     23
     D  ZSLOC                 24     26
     D  ZSWEXX                27     30  0
     D  ZSJAN                 31     33P 0
     D  ZSDCM                 34     36P 0
     D  RTNCD                 37     43
     D  @ZWRKO                21     43
 
     D  ZOPTN                 44     50
     D  ZZCCY                 51     53
     D  ZZLOC                 54     56
     D  ZZDYNO                57     59P 0
     D  ZSRTN                 60     66
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIdXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIx
     C                   MOVE      *BLANKS       WDATE
     C                   MOVE      'Y'           DDACRFOK
     C                   MOVE      'Y'           DDNSDTOK
 
     C                   IF        DDACRF <> ' ' AND
     C                             DDACRF <> 'D' AND
     C                             DDACRF <> 'W' AND
     C                             DDACRF <> 'F' AND
     C                             DDACRF <> 'M' AND
     C                             DDACRF <> 'T' AND
     C                             DDACRF <> 'Q' AND
     C                             DDACRF <> '4' AND
     C                             DDACRF <> '5' AND
     C                             DDACRF <> 'X' AND
     C                             DDACRF <> '7' AND
     C                             DDACRF <> '8' AND
     C                             DDACRF <> '9' AND
     C                             DDACRF <> 'V' AND
     C                             DDACRF <> 'E' AND
     C                             DDACRF <> 'Y' AND
     C                             DDACRF <> 'C' AND
     C                             DDACRF <> 'I' AND
     C                             DDACRF <> 'J' AND
     C                             DDACRF <> 'N' AND
     C                             DDACRF <> 'U'
 
     C                   MOVE      'N'           DDACRFOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDACRF'      FldNamXAr(Idx)
     C                   MOVEL     'USS0206'     MsgIdXAr(Idx)
 
     C                   ELSE
     C                   EVAL      DFACRF = DDACRF
     C                   ENDIF
 
     C                   IF        DDNSDF <> *BLANK
     C                   TESTN                   DDNSDF               95
     C     *IN95         IFEQ      *OFF
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARNSDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0207'
     C                   ELSE
     C                   MOVE      DDNSDF        WUWSDT
 
      ** Check Screen Date - Run date
 
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM                    W0RTN
     C     WUWSDT        PARM                    WUWSDT
     C     WUDFF         PARM      WWDFIN        WUDFF
     C     WUWFDT        PARM      *ZERO         WUWFDT
 
     C                   IF        *IN90 = *ON
 
      ** Send message '*Error occured on CALL...'
 
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARNSDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'Y2U0032'
     C                   EVAL      MsgDtaXAr(Idx) = 'ZDATE1'
     C                   ENDIF
 
     C                   IF        W0RTN = '*ERROR*'
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARNSDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0207'
     C                   ELSE
 
     C                   IF        WUWFDT < WWRDNB
     C                   EVAL      DDNSDTOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C**********         EVAL      FldNamXAr(Idx) = 'ARNSDT    '                            MD026207
     C                   EVAL      FldNamXAr(Idx) = 'DDNSDF    '                            MD026207
     C                   EVAL      MsgIdXAr(Idx)  = 'USS0398'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDACRF = ' '
 
     C                   CALLB     'ZCHKH'
     C                   PARM      WUWFDT        ZDAYNO
     C                   PARM      WWLCCY        ZCCY
     C                   PARM      WWSLCD        ZLOC
     C                   PARM      *BLANK        ZIND
 
     C                   IF        ZIND = 'H' AND
     C**********                   WDCOMP = 'N'                                             MD027575
     C                             WDCOMP <> 'Y'                                            MD027575
     C                   EVAL      WIx = WIx + 1
     C**********         EVAL      WFldNmXAr(WIx) = 'ARSCDT    '                            MD027575
     C                   EVAL      WFldNmXAr(WIx) = 'ARNSDT    '                            MD027575
     C                   EVAL      WMsgIdXAr(WIx) = 'USS0197'
     C                   ENDIF
 
     C                   EVAL      DFNSDT = WUWFDT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDACRF <> ' ' AND
     C                             DFSCDT <> *ZERO AND
     C                             DDACRFOK = 'Y' AND
     C                             DDSCDTOK = 'Y' AND
     C                             DDNSDTOK <> 'N'
     C                   EVAL      ZFREQ = DDACRF
     C                   EVAL      ZDAYNO = DFSCDT
     C                   EVAL      ZCCY = WWCYCD
     C                   EVAL      ZLOC = *BLANKS
 
     C                   EXSR      ZNDAR
                                                                                            MD027573
     C**********         DOW       ZDAYNO < WWRDNB                                MD027573 MD027573A
     C                   DOW       ZDAYNO <= WWRDNB                                        MD027573A
     C                   EXSR      ZNDAR                                                    MD027573
     C                   ENDDO                                                              MD027573
 
     C                   IF        DDNSDF <> *BLANK
 
     C                   MOVE      ZDATE         WDATE
 
     C                   CALLB     'ZCHKH'
     C                   PARM      WUWFDT        ZDAYNO
     C                   PARM      WWLCCY        ZCCY
     C                   PARM      WWSLCD        ZLOC
     C                   PARM      *BLANK        ZIND
 
     C                   IF        ZIND = 'H' AND
     C**********                   WDCOMP = 'N'                                             MD027575
     C                             WDCOMP <> 'Y'                                            MD027575
     C                   EVAL      WIx = WIx + 1
     C                   EVAL      WFldNmXAr(WIx) = 'ARNSDT    '
     C                   EVAL      WMsgIdXAr(WIx) = 'USS0197'
     C                   ENDIF
 
     C                   IF        DDNSDF <> WDATE
     C**********         EVAL      WIx = WIx + 1                        MD025689
     C**********         EVAL      WFldNmXAr(WIx) = 'ARNSDT    '        MD025689
     C**********         EVAL      WMsgIdXAr(WIx) = 'USS0194'           MD025689
     C                   ELSE
     C                   MOVE      ZDATE         DDNSDF
     C                   ENDIF
     C                   EVAL      DFNSDT = WUWFDT
 
     C                   ELSE
 
     C                   EVAL      ZIND = 'H'
     C                   DOW       ZIND = 'H'
     C                   CALLB     'ZCHKH'
     C                   PARM      ZDAYNO        ZDAYNO
     C                   PARM      WWLCCY        ZCCY
     C                   PARM      WWSLCD        ZLOC
     C                   PARM      *BLANK        ZIND
 
     C                   IF        ZIND = 'H'
     C                   EVAL      ZDAYNO = ZDAYNO - 1
     C                   ENDIF
     C                   ENDDO
 
      *
      ** If generate Next Scheduled date is equal to Scheduled Date,
      ** Switch to after mode.
      *
     C                   IF        ZDAYNO =  DFSCDT
     C                             OR ZDAYNO < DFSCDT
     C                   EVAL      ZIND = 'H'
     C                   EVAL      ZDAYNO = ZDAYNO + 1
      *
     C                   DOW       ZIND = 'H'
     C                   CALLB     'ZCHKH'
     C                   PARM      ZDAYNO        ZDAYNO
     C                   PARM      WWLCCY        ZCCY
     C                   PARM      WWSLCD        ZLOC
     C                   PARM      *BLANK        ZIND
      *
     C                   IF        ZIND = 'H'
     C                   EVAL      ZDAYNO = ZDAYNO + 1
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    WWDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
      ** If Complete flag is 'N' and Account Review Next Schedule Date
      ** is *Blank, do not default Next Schedule Date
 
     C                   IF        DDCOMP = 'Y'
     C                             AND DDNSDF = *BLANKS
     C                   MOVE      ZDATE         DDNSDF
     C                   EVAL      DFNSDT = ZDAYNO
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Return
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: SDACRV1VL                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    ReturnCode
 
      ** Account Review Frequency
     C                   PARM                    DDACRF
 
      ** Next Schedule Date
     C                   PARM                    DDNSDF
 
      ** Account Review Complete
     C                   PARM                    DDCOMP
 
     C                   PARM                    WDCOMP
     C                   PARM                    WWDFIN
     C                   PARM                    WWCYCD
     C                   PARM                    WWLCCY
     C                   PARM                    WWSLCD
     C                   PARM                    WWRDNB            5 0
 
     C                   PARM                    DFSCDT
     C                   PARM                    DDSCDTOK
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIdXAr
     C                   PARM                    WMsgDtXAr
 
      ** Account Review Frequency
     C                   PARM                    DDACRFOK
 
      ** Next Schedule Date
     C                   PARM                    DDNSDTOK
 
     C                   PARM                    DFACRF
     C                   PARM                    DFNSDT
 
     C     WWDFIN        COMP      'M'                                    98
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C/COPY ZSRSRC,ZCHKHLE
     C/COPY ZSRSRC,ZNDAR_ILE
     C/COPY ZSRSRC,ZACCHLE
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
