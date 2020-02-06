     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate deal date, 1st/2nd leg dates')       *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVDATES - Validate Deal Date, 1st Leg Date, 2nd Leg Date    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 09May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 217693             Date 26May06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 181568             Date 11Aug00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  217693 - Int. Contracts maint. - no warning msg.             *
      *  181568 - Recompiled, as menu option AICN ended in Database   *
      *           error.                                              *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              217693
      ** Index for arrays of error message ids etc                                            217693
     D WIx             S              3P 0                                                    217693
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D ZNRDYS          S              2S 0
 
      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D                 DS
     D  @YMD                   1      8  0
     D  @YYYY                  1      4  0
     D  @MM                    5      6  0
     D  @DD                    7      8  0
 
     D @RETN           S              1A
 
      ** DEAL DATE YYYY/MM/DD
     D JUDDYY          S              4S 0
     D JUDDMM          S              2S 0
     D JUDDDD          S              2S 0
 
      ** NEAR DATE YYYY/MM/DD
     D JUNDYY          S              4S 0
     D JUNDMM          S              2S 0
     D JUNDDD          S              2S 0
 
      ** FAR DATE YYYY/MM/DD
     D JUFDYY          S              4S 0
     D JUFDMM          S              2S 0
     D JUFDDD          S              2S 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        WFldNmXAr                                    217693
     C                   MOVE      *BLANK        WMsgIDXAr                                    217693
     C                   MOVE      *BLANK        WMsgDtXAr                                    217693
     C                   Z-ADD     0             WIx                                          217693
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** Clear output deal fields
 
     C                   Z-ADD     *ZERO         JUDDAT
     C                   Z-ADD     *ZERO         JUDDYY                           Deal Year
     C                   Z-ADD     *ZERO         JUDDMM                                Month
     C                   Z-ADD     *ZERO         JUDDDD                                Day
 
     C                   Z-ADD     *ZERO         JUNDAT
     C                   Z-ADD     *ZERO         JUNDYY                           Year
     C                   Z-ADD     *ZERO         JUNDMM                           Month
     C                   Z-ADD     *ZERO         JUNDDD                           Day
 
     C                   Z-ADD     *ZERO         JUFDAT
     C                   Z-ADD     *ZERO         JUFDYY                           Year
     C                   Z-ADD     *ZERO         JUFDMM                           Month
     C                   Z-ADD     *ZERO         JUFDDD                           Day
      *
      * DLDTV - DEAL DATE VALIDATION
      *
     C                   EXSR      DLDTV
      *
      * L1DTV - 1ST LEG VALUE DATE VALIDATION
      *
     C                   EXSR      L1DTV
      *
      * L2DTV - 2ND LEG VALUE DATE VALIDATION
      *
     C                   EXSR      L2DTV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDldtOK      IFEQ      'N'
     C     DDL1DTOK      OREQ      'N'
     C     DDL2DTOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * DLDTV - DEAL DATE VALIDATION
      *****************************************************************
     C     DLDTV         BEGSR
      *
      * If Deal date is blank, default it to run date
      *
     C     DDDLDT        IFEQ      *BLANKS
     C                   CALLB     'ZDATE2'
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DDDLDT
     C                   END
      *
      * Test if deal date is numeric
      * If it is, convert it to a day number
      *
     C                   TESTN                   DDDLDT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDDLDT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    DealDtDN          5 0
     C                   END
      *
      * Deal date is invalid
      * or is not numeric
      *
     C     RetCodeOut    IFEQ      'Error'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0113'     MsgIdXAr(Idx)
     C                   GOTO      EDLDTV
     C                   END
      *
      * Deal date can't be in the future
      *
     C     DealDtDN      IFGT      BJRDNB
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0103'     MsgIdXAr(Idx)
     C                   GOTO      EDLDTV
     C                   END
      *
      ** If system is single-branch
      ** Check that deal date is not a holiday in local currency
      *
     C     BJSBRC        IFNE      *BLANK
     C                   CALLB     'ZCHKH'
     C                   PARM      DealDtDN      ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BJSLCD        ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     ZIND          IFEQ      'H'
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0114'     MsgIdXAr(Idx)
     C                   GOTO      EDLDTV
     C                   END
     C                   END
      *
      ** If system is multi-branching
      ** and if booking branch is valid,
      ** Check that deal date is not a holiday in branch location
      *
     C     BJSBRC        IFEQ      *BLANK
     C     DDBRCDOK      ANDEQ     'Y'
     C                   CALLB     'ZCHKH'
     C                   PARM      DealDtDN      ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY              3
     C                   PARM      BkgBrLCCD     ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C     ZIND          IFEQ      'H'
     C                   MOVE      'N'           DDDldtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLDT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0114'     MsgIdXAr(Idx)
     C                   GOTO      EDLDTV
     C                   END
     C                   END
      *
      * Output deal date day number and yyyy/mm/dd
      *
     C                   Z-ADD     DealDtDN      JUDDAT
     C                   CALLB     'ZDATE9'
     C                   PARM      JUDDAT        @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YYYY         JUDDYY                           Deal Year
     C                   Z-ADD     @MM           JUDDMM                                Month
     C                   Z-ADD     @DD           JUDDDD                                Day
      *
     C     EDLDTV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * L1DTV - 1ST LEG VALUE DATE VALIDATION
      *****************************************************************
     C     L1DTV         BEGSR
      *
      *  If 1st leg value date is not defined, default it to run date+2 days
      *
     C     DDL1DT        IFEQ      *BLANKS
      *
     C                   CALLB     'ZF2C'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      BJRDNB        ZDAYNO            5 0
     C                   PARM      BJLCCY        ZCCY1             3
     C                   PARM      BJSLCD        ZLOC1             3
     C                   PARM      BJHOCY        ZCCY2             3
     C                   PARM      *BLANKS       ZLOC2             3
     C                   PARM      2             ZNRDYS
     C                   PARM      *ZERO         ZDYNBR            5 0
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      ZDYNBR        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZDATE         DDL1DT
     C                   END
      *
      *  If 1st leg value date is numeric, convert it to a day number
      *
     C                   TESTN                   DDL1DT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDL1DT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    L1VlDtDN          5 0
     C                   END
      *
      *  Error if 1st leg value date is not numeric or is an invalid date
      *
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C     RetCodeOut    OREQ      'Error'
     C                   MOVE      'N'           DDL1DTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1DT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0148'     MsgIdXAr(Idx)
     C                   GOTO      EL1DTV
     C                   END
      *
      * 1st leg value date can't be less than 1st deal date
      *
     C     L1VlDtDN      IFLT      JUDDAT
     C                   MOVE      'N'           DDL1DTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL1DT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0202'     MsgIdXAr(Idx)
     C                   GOTO      EL1DTV
     C                   END
                                                                                              217693
      ** Send warning if date is holiday                                                      217693
                                                                                              217693
      ** Against local currency                                                               217693
     C                   CALLB     'ZCHKH'                                                    217693
     C                   PARM      L1VlDtDN      ZDAYNO                                       217693
     C                   PARM      BJLCCY        ZCCY                                         217693
     C                   PARM      BkgBrLCCD     ZLOC                                         217693
     C                   PARM      *BLANK        ZIND                                         217693
     C     ZIND          IFEQ      'H'                                                        217693
     C                   MOVE      'W'           DDL1DTOK                                     217693
     C                   ADD       1             WIx                                          217693
     C                   MOVEL     'DDL1DT'      WFldNmXAr(WIx)                               217693
     C                   MOVEL     'ABM0605'     WMsgIdXAr(WIx)                               217693
     C**********         MOVEL     BJLCCY        WMsgDtXAr(WIx)                      217693 MD000091
     C                   EVAL      BLen = %Len(%Trim(BJLCCY))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(BJLCCY)                   MD000091
     C                   ENDIF                                                                217693
                                                                                              217693
      ** Against L1 buy currency                                                              217693
     C     DDL1CB        IFNE      BJLCCY                                                     217693
     C                   CALLB     'ZCHKH'                                                    217693
     C                   PARM      L1VlDtDN      ZDAYNO                                       217693
     C                   PARM      DDL1CB        ZCCY                                         217693
     C                   PARM      *BLANKS       ZLOC                                         217693
     C                   PARM      *BLANK        ZIND                                         217693
     C     ZIND          IFEQ      'H'                                                        217693
     C                   MOVE      'W'           DDL1DTOK                                     217693
     C                   ADD       1             WIx                                          217693
     C                   MOVEL     'DDL1DT'      WFldNmXAr(WIx)                               217693
     C                   MOVEL     'ABM0604'     WMsgIdXAr(WIx)                               217693
     C**********         MOVEL     DDL1CB        WMsgDtXAr(WIx)                      217693 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDL1CB))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DDL1CB)                   MD000091
     C                   ENDIF                                                                217693
     C                   ENDIF                                                                217693
                                                                                              217693
      ** Against L1 sell currency                                                             217693
     C     DDL1CS        IFNE      BJLCCY                                                     217693
     C                   CALLB     'ZCHKH'                                                    217693
     C                   PARM      L1VlDtDN      ZDAYNO                                       217693
     C                   PARM      DDL1CS        ZCCY                                         217693
     C                   PARM      *BLANKS       ZLOC                                         217693
     C                   PARM      *BLANK        ZIND                                         217693
     C     ZIND          IFEQ      'H'                                                        217693
     C                   MOVE      'W'           DDL1DTOK                                     217693
     C                   ADD       1             WIx                                          217693
     C                   MOVEL     'DDL1DT'      WFldNmXAr(WIx)                               217693
     C                   MOVEL     'ABM0604'     WMsgIdXAr(WIx)                               217693
     C**********         MOVEL     DDL1CS        WMsgDtXAr(WIx)                      217693 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDL1CS))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DDL1CS)                   MD000091
     C                   ENDIF                                                                217693
     C                   ENDIF                                                                217693
      *
      * Output 1st leg value date (near date) day number and yyyy/mm/dd
      *
     C                   Z-ADD     L1VlDtDN      JUNDAT
     C                   CALLB     'ZDATE9'
     C                   PARM      JUNDAT        @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YYYY         JUNDYY                           Year
     C                   Z-ADD     @MM           JUNDMM                           Month
     C                   Z-ADD     @DD           JUNDDD                           Day
      *
     C     EL1DTV        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * L2DTV - 2ND LEG VALUE DATE VALIDATION
      *****************************************************************
     C     L2DTV         BEGSR
      *
      *  Error if 2nd leg value date is blank
      *
     C     DDL2DT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDL2DTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL2DT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0143'     MsgIdXAr(Idx)
     C                   GOTO      EL2DTV
     C                   END
      *
      *  If 2nd leg value date is numeric, convert it to a day number
      *
     C                   TESTN                   DDL2DT               9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM      DDL2DT        @@DATE            6
     C                   PARM                    BJDFIN
     C                   PARM                    L2VlDtDN          5 0
     C                   END
      *
      *  Error if 2nd leg value date is not numeric or is an invalid date
      *
     C     *IN97         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
     C     RetCodeOut    OREQ      'Error'
     C                   MOVE      'N'           DDL2DTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL2DT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0149'     MsgIdXAr(Idx)
     C                   GOTO      EL2DTV
     C                   END
      *
      * 2nd leg value date can't be less than 1st leg value date
      *
     C     L2VlDtDN      IFLT      JUNDAT
     C                   MOVE      'N'           DDL2DTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDL2DT'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0104'     MsgIdXAr(Idx)
     C                   GOTO      EL2DTV
     C                   END
                                                                                              217693
      ** Send warning if date is holiday                                                      217693
                                                                                              217693
      ** Against local currency                                                               217693
     C                   CALLB     'ZCHKH'                                                    217693
     C                   PARM      L2VlDtDN      ZDAYNO                                       217693
     C                   PARM      BJLCCY        ZCCY                                         217693
     C                   PARM      BkgBrLCCD     ZLOC                                         217693
     C                   PARM      *BLANK        ZIND                                         217693
     C     ZIND          IFEQ      'H'                                                        217693
     C                   MOVE      'W'           DDL2DTOK                                     217693
     C                   ADD       1             WIx                                          217693
     C                   MOVEL     'DDL2DT'      WFldNmXAr(WIx)                               217693
     C                   MOVEL     'ABM0607'     WMsgIdXAr(WIx)                               217693
     C**********         MOVEL     BJLCCY        WMsgDtXAr(WIx)                      217693 MD000091
     C                   EVAL      BLen = %Len(%Trim(BJLCCY))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(BJLCCY)                   MD000091
     C                   ENDIF                                                                217693
                                                                                              217693
      ** Against L2 buy currency                                                              217693
     C     DDL2CB        IFNE      BJLCCY                                                     217693
     C                   CALLB     'ZCHKH'                                                    217693
     C                   PARM      L2VlDtDN      ZDAYNO                                       217693
     C                   PARM      DDL2CB        ZCCY                                         217693
     C                   PARM      *BLANKS       ZLOC                                         217693
     C                   PARM      *BLANK        ZIND                                         217693
     C     ZIND          IFEQ      'H'                                                        217693
     C                   MOVE      'W'           DDL2DTOK                                     217693
     C                   ADD       1             WIx                                          217693
     C                   MOVEL     'DDL2DT'      WFldNmXAr(WIx)                               217693
     C                   MOVEL     'ABM0606'     WMsgIdXAr(WIx)                               217693
     C**********         MOVEL     DDL2CB        WMsgDtXAr(WIx)                      217693 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDL2CB))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DDL2CB)                   MD000091
     C                   ENDIF                                                                217693
     C                   ENDIF                                                                217693
                                                                                              217693
      ** Against L2 sell currency                                                             217693
     C     DDL2CS        IFNE      BJLCCY                                                     217693
     C                   CALLB     'ZCHKH'                                                    217693
     C                   PARM      L2VlDtDN      ZDAYNO                                       217693
     C                   PARM      DDL2CS        ZCCY                                         217693
     C                   PARM      *BLANKS       ZLOC                                         217693
     C                   PARM      *BLANK        ZIND                                         217693
     C     ZIND          IFEQ      'H'                                                        217693
     C                   MOVE      'W'           DDL2DTOK                                     217693
     C                   ADD       1             WIx                                          217693
     C                   MOVEL     'DDL2DT'      WFldNmXAr(WIx)                               217693
     C                   MOVEL     'ABM0606'     WMsgIdXAr(WIx)                               217693
     C**********         MOVEL     DDL2CS        WMsgDtXAr(WIx)                      217693 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDL2CS))                               MD000091
     C                   EVAL      WMsgDtXAr(WIx) = LenStr +%TRIM(DDL2CS)                   MD000091
     C                   ENDIF                                                                217693
     C                   ENDIF                                                                217693
      *
      * Output 2nd leg value date (far date) day number and yyyy/mm/dd
      *
     C                   Z-ADD     L2VlDtDN      JUFDAT
     C                   CALLB     'ZDATE9'
     C                   PARM      JUFDAT        @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YYYY         JUFDYY                           Year
     C                   Z-ADD     @MM           JUFDMM                           Month
     C                   Z-ADD     @DD           JUFDDD                           Day
      *
     C     EL2DTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Deal Date
      ** 1st Leg Value Date
      ** 2nd Leg Value Date
     C                   PARM                    DDDLDT            6
     C                   PARM                    DDL1DT            6
     C                   PARM                    DDL2DT            6
     C                   PARM                    DDL1CB            3                          217693
     C                   PARM                    DDL1CS            3                          217693
     C                   PARM                    DDL2CB            3                          217693
     C                   PARM                    DDL2CS            3                          217693
      *
      ** Booking branch OK
     C                   PARM                    DDBRCDOK          1
      *
      * Booking branch location
     C                   PARM                    BkgBrLCCD         3
      *
      * ICD
      *
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJSBRC            3
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJHOCY            3
      *
      * OUTPUTS
                                                                                              217693
      * Warning felds/message IDs/message data (arrays) from/to caller                        217693
     C                   PARM                    WFldNmXAr                                    217693
     C                   PARM                    WMsgIdXAr                                    217693
     C                   PARM                    WMsgDtXAr                                    217693
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Deal Date - OK
      ** 1st Leg Value date - OK
      ** 2nd Leg Value date - OK
     C                   PARM                    DDDLDTOK          1
     C                   PARM                    DDL1DTOK          1
     C                   PARM                    DDL2DTOK          1
      *
      ** Deal Date, 1st Leg (Near) Value Date, 2nd Leg (Far) Value Date
      *
     C                   PARM                    JUDDAT            5 0
     C                   PARM                    JUDDYY
     C                   PARM                    JUDDMM
     C                   PARM                    JUDDDD
 
     C                   PARM                    JUNDAT            5 0
     C                   PARM                    JUNDYY
     C                   PARM                    JUNDMM
     C                   PARM                    JUNDDD
 
     C                   PARM                    JUFDAT            5 0
     C                   PARM                    JUFDYY
     C                   PARM                    JUFDMM
     C                   PARM                    JUFDDD
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
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
