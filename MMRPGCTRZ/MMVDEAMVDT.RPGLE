     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate Deal Amendment Value Date')          *
      *****************************************************************
      *                                                               *
      *  Midas - Common Validation Routine                            *
      *                                                               *
      *  MMVDEAMVDT - Validate Deal Amendment Value Date              *
      *               (for Deal Amendment processing)                 *
      *                                                               *
      *  Function:  This module receives a parameter containing the   *
      *             Deal Amendment Value Date and confirms if valid.  *
      *             If it is valid the 10A return code will be blank; *
      *             if not it will contain 'Error'                    *
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
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 03Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMDEAMPP *
      *  CAP002 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +----------------------------+
      ** ¦ Manually Included F-Specs  ¦
      ** ¦ =========================  ¦
      ** +----------------------------+
      **
     FMMLVDMLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MMDEAMP0:MMLVDMP0)
      **
      ** +-----------------------------------+
      ** ¦ End of Manually Included F-Specs  ¦
      ** ¦ ================================  ¦
      ** +-----------------------------------+
      **
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D                 DS
     D**  Data Structure to split value date used in key to deams file
     D  @KVALD                 1      8  0
     D  @VDYY                  1      4  0
     D  @VYEAR                 3      4  0
     D  @VDMM                  5      6  0
     D  @VDDD                  7      8  0
 
     D                 DS
     D**  Data structure for convertion of YYMMDD to DDMMYY
     D  @DMVDT                 1      6
     D  @DMVD                  1      2
     D  @DMVM                  3      4
     D  @DMVY                  5      6
 
     D                 DS
     D**  Data Structure for screen value date (received as a parameter)
     D  @VDAT                  1      6
     D  @DSPD                  1      2
     D  @DSPM                  3      4
     D  @DSPY                  5      6
 
      ** External data structure for access programs (short)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D @DEAM         E DS                  EXTNAME(MMDEAMPP)
     D  @DMVYR                51     52
     D  @DMVMT                53     54
     D  @DMVDY                55     56
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 received as a parameter
     D Msgid1          S                   LIKE(#MSGID)
 
      ** Warning message code 1 received as a parameter
     D WMsgid1         S                   LIKE(#MSGID)
 
      ** Value Date received as a parameter
     D DDVDAT          S              6A
 
      ** Deal Amendment Type received as a parameter
     D DDMTYP          S              2A
 
      ** Action Code received as a parameter
     D DDACTN          S              1A
 
      ** Deal Number received as a parameter
     D DDDLNO          S              6A
 
      ** Record ID from original deal received as a parameter
     D H@RCID          S              2A
 
      ** Currency from original deal received as a parameter
     D H@CCY           S              3A
 
      ** Notice Days from original deal passed as parameter
     D H@NTCE          S              3S 0
 
      ** Run Day Number from SDBANKPD received as paramater
     D BJRDNB          S              5  0
 
      ** Local Currency Code from SDBANKPD received as paramater
     D BJLCCY          S              3A
 
      ** Date Format Indicator from SDBANKPD received as paramater
     D BJDFIN          S              1A
 
      ** System Location Code from SDBANKPD received as paramater
     D BJSLCD          S              3A
 
      ** Location Code (last 3 characters from Nostro Shortname A7NOSN)
      ** received as paramater
     D @RLOC           S              3A
 
      ** Value Date in Midas Day Number format returned as a parameter
     D ValueDate       S              5  0
 
      ** Valid Value Date reformated returned as a parameter
     D IGVDYY          S              4S 0
     D IGVDMM          S              2S 0
     D IGVDDD          S              2S 0
 
      ** Fields used in call to ZF2C
     D DateIn          S              5  0
     D FirstCcy        S              3A
     D FirstLoc        S              3A
     D SecondCcy       S              3A
     D SecondLoc       S              3A
     D NumDaysFwd      S              2S 0
     D DayNumber       S              5  0
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
     C                   RESET                   Msgid1
     C                   RESET                   WMsgid1
     C                   RESET                   WarnGlobal
      *
     C                   EVAL      @VDAT = DDVDAT
      *
      *  *------------------------------*
      *  * Validate Value Date          *
      *  *------------------------------*
     C*
     C**  Validate that the value date is a valid date
     C     DDVDAT        IFNE      *BLANKS
     C                   TESTN                   DDVDAT               6263
     C                   MOVE      DDVDAT        @TEST             1
     C                   TESTZ                   @TEST                    73
     C     *IN62         IFEQ      '1'
     C     *IN73         ANDEQ     '1'
     C     *IN63         OREQ      '1'
     C     *IN73         ANDEQ     '1'
     C                   MOVEL     DDVDAT        @DAT
     C                   CALLB     'ZA0270'
     C                   PARM                    @DAT              6 0
     C                   PARM                    BJDFIN
     C                   PARM                    @RTCDE            1
     C                   PARM                    ValueDate
     C                   END
     C                   END
     C*
     C**  If the return code is 1 then the input date is invalid or
     C**  non-numeric.
     C     @RTCDE        IFEQ      '1'
     C     DDVDAT        OREQ      *BLANKS
     C     *IN73         OREQ      '0'
     C     *IN62         OREQ      '0'
     C     *IN63         ANDEQ     '0'
     C*
     C                   MOVE      'Y'           ErrorFound
     C                   MOVEL     'MMM0125'     MsgId1
     C                   GOTO      DEAMVDTEND
     C                   END
     C*
     C** Load value date to numeric keyfield,in YYYYMMDD format
     C                   Z-ADD     0             @KVALD
     C                   MOVE      @DSPY         @VYEAR
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPD         @VDDD
     C                   ELSE
     C                   MOVE      @DSPD         @VDMM
     C                   END
 
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DSPM         @VDMM
     C                   ELSE
     C                   MOVE      @DSPM         @VDDD
     C                   END
     C*
     C** Century
     C     @VYEAR        IFGE      72
     C     @VDYY         ADD       1900          @VDYY
     C                   ELSE
     C     @VDYY         ADD       2000          @VDYY
     C                   END
     C*
     C**  Find whether the date is a holiday in the local currency.
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ValueDate
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    HolidayInd        1
     C*
     C*   If HolidayInd = 'H' then the date is a holiday.
     C     HolidayInd    IFEQ      'H'
     C                   MOVE      'Y'           WarnFound
     C                   MOVEL     'MMM0131'     WMsgId1
     C                   GOTO      DEAMVDTEND
     C                   END
     C*
     C** For deam type 'SI' the deam value date must not be the same
     C** as the value date of a deam already existing on the deal.
     C** Also applys to deam type 'CI'.
     C     DDMTYP        IFEQ      'SI'
     C     DDACTN        ANDEQ     'I'
     C     DDMTYP        OREQ      'CI'
     C     DDACTN        ANDEQ     'I'
     C*
     C** Check for all possible deam sequence  values
     C                   MOVE      DDDLNO        @DLKEY
     C                   MOVE      *LOVAL        @KSEQN
     C**  Read for a deal with the same value date and deal no
     C     @DMKEY        SETLL     MMLVDMLL
     C                   READ      MMLVDMLL                               65
     C*
     C**  Place value date from files into same sequence as display (DDMMYY)
     C                   MOVE      @DMVYR        @DMVY
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      @DMVMT        @DMVM
     C                   MOVE      @DMVDY        @DMVD
     C                   ELSE
     C                   MOVE      @DMVMT        @DMVD
     C                   MOVE      @DMVDY        @DMVM
     C                   END
     C*
     C**  If a live record is found then a deam already exists
     C**  for the value date & deal number
     C     *IN65         IFEQ      '0'
     C     @DLKEY        ANDEQ     HNDA38
     C     DDVDAT        ANDEQ     @DMVDT
      *
     C                   MOVE      'Y'           ErrorFound
     C     DDMTYP        IFEQ      'SI'
     C                   MOVEL     'MMM0577'     MsgId1
     C                   ELSE
     C                   MOVEL     'MMM2548'     MsgId1
     C                   END
     C                   END
     C*
     C                   END
     C*
     C** Send warning message if notice days are not 0 or -999
     C** & value date is greater than the run date + associated deal
     C** notice days.
     C** Only loan/deposit/cd issued can have notice days
     C*
     C     ErrorFound    IFNE      'Y'
     C     H@RCID        ANDEQ     'HK'
     C*
     C* Calculate no. of notice days forward in both deal and local ccy
     C                   Z-ADD     BJRDNB        DateIn
     C                   MOVE      H@CCY         FirstCCy
     C                   MOVE      @RLOC         FirstLoc
     C                   MOVE      BJLCCY        SecondCcy
     C                   MOVE      BJSLCD        SecondLoc
     C                   Z-ADD     H@NTCE        NumDaysFwd
     C                   RESET                   ReturnCode
 
     C                   CALLB     'ZF2C'
     C                   PARM                    ReturnCode
     C                   PARM                    DateIn
     C                   PARM                    FirstCcy
     C                   PARM                    FirstLoc
     C                   PARM                    SecondCcy
     C                   PARM                    SecondLoc
     C                   PARM                    NumDaysFwd
     C                   PARM                    DayNumber
     C*
     C                   Z-ADD     DayNumber     @CMDT             5 0
     C*
     C     H@NTCE        IFNE      *ZEROS
     C     H@NTCE        ANDNE     -999
     C     ValueDate     ANDGT     @CMDT
     C                   MOVE      'Y'           WarnFound
     C                   MOVEL     'MMM0155'     WMsgId1
     C                   END
     C                   END
     C*
     C     DEAMVDTEND    TAG
 
     C** No error set up value date for output
     C                   IF        ErrorFound = 'N'
     C                   Z-ADD     @VDYY         IGVDYY
     C                   Z-ADD     @VDMM         IGVDMM
     C                   Z-ADD     @VDDD         IGVDDD
     C                   ENDIF
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    Msgid1
     C                   PARM                    WMsgid1
     C                   PARM                    DDVDAT
     C                   PARM                    DDMTYP
     C                   PARM                    DDACTN
     C                   PARM                    DDDLNO
     C                   PARM                    H@RCID
     C                   PARM                    H@CCY
     C                   PARM                    H@NTCE
     C                   PARM                    BJRDNB
     C                   PARM                    BJLCCY
     C                   PARM                    BJDFIN
     C                   PARM                    BJSLCD
     C                   PARM                    @RLOC
     C                   PARM                    ValueDate
     C                   PARM                    IGVDYY
     C                   PARM                    IGVDMM
     C                   PARM                    IGVDDD
 
     C** Deam key fields
     C     @DMKEY        KLIST
     C                   KFLD                    @DLKEY            6 0
     C                   KFLD                    @VDYY
     C                   KFLD                    @VDMM
     C                   KFLD                    @VDDD
     C                   KFLD                    @KSEQN            3 0
     C*
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
