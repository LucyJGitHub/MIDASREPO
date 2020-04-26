     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate BRT Participant Date of Birth')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVPADT  - Validate Base Rate Tax Participant Date of Birth  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD055446           Date 04Apr20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 22Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055446 - There are parties and fields missing from the BRT *	
      *             details tab in Customer Input plus date of birth  *	
      *             issues.                                           *	
      *           - BRT Participation Date of Birth field is missing. *
      *             Adjusted span of acceptable Date of Birth.        *
      *           - Increased the field length of DDXDOB and changed  *
      *             birth date validation to include century field.   *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************
 
      *  Use of Indicators:                                           *                     MD055446
      *                                                               *                     MD055446
      *    66 - Day and Month error checking.                         *                     MD055446
      *    67 - 30 days months.                                       *                     MD055446
      *    68 - Leap year.                                            *                     MD055446
      *    69 - Month of February.                                    *                     MD055446
      *    70 - Months, March onwards.                                *                     MD055446
 
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
      ** Array for year                                                                     MD055446
     D BZYDY           S              4  0 DIM(4) CTDATA PERRCD(4)                          MD055446
      ** Array for month                                                                    MD055446
     D BZMDY           S              3  0 DIM(13) CTDATA PERRCD(13)                        MD055446
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Zoned definition for date of birth field
     D*BRXDOB***       S              6P 0                                                  MD055446
     D BRXDOB          S              8P 0                                                  MD055446
      ** Temporary variable for century and year field                                      MD055446
     D BWYEAR          S              4P 0                                                  MD055446
      ** Temporary variable for date checking                                               MD055446
     D BZDATE          S              8P 0                                                  MD055446
      ** Temporary variable for 5-digit date output                                         MD055446
     D BDAYNO          S              5P 0                                                  MD055446
      ** Temporary variable for 4-digit year                                                MD055446
     D BZYEAR          S              4P 0                                                  MD055446
      ** Temporary variable for 2-digit month                                               MD055446
     D BZMTH           S              2P 0                                                  MD055446
      ** Temporary variable for 2-digit day                                                 MD055446
     D BZDAY           S              2P 0                                                  MD055446
      ** Temporary variable to split up year and month                                      MD055446
     D BZWRK4          S              6P 0                                                  MD055446
      ** Temporary variable for 2-digit leap year checking                                  MD055446
     D BZLYR           S              2P 0                                                  MD055446
      ** Temporary variable for the remainder of leap year check                            MD055446
     D BZLY            S              1P 0                                                  MD055446
 
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
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      ** comments
 
      *
      ** VALIDATION
      *
     C                   EXSR      VXDOB
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDXDOBOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VXDOB         BEGSR
 
      * If participant name not entered, return
     C     DDXNAM        IFEQ      *BLANKS
     C                   Z-ADD     0             BRXDOB
     C                   GOTO      EndVXDOB
     C                   ENDIF
 
      * If BRT liable flag is N, date of birth must be entered
     C     DDXBRT        IFEQ      'N'
     C     DDXDOB        ANDEQ     *BLANKS
     C     DDAHLT        ANDNE     'R'                                                        CRE007
     C                   MOVE      'N'           DDXDOBOK
     C                   ADD       1             Idx
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)
     C                   MOVEL     'USR4156'     MsgIdXAr(Idx)
     C                   ENDIF
 
      * Date of birth must be numeric
      *                                                                                     MD055446
      ** Initialize indicators.                                                             MD055446
      *                                                                                     MD055446
     C                   MOVEA     '00000'       *IN(66)                                    MD055446
      *                                                                                     MD055446
     C     DDXDOB        IFNE      *BLANKS
     C                   TESTN                   DDXDOB               98
     C     *IN98         IFEQ      *OFF
     C                   MOVE      'N'           DDXDOBOK
     C                   ADD       1             Idx
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)
     C                   MOVEL     'USR4157'     MsgIdXAr(Idx)
     C                   GOTO      EndVXDOB
     C                   ENDIF
 
      * Date of birth must be a valid date
     C**********         MOVE      DDXDOB        ZDATEA                                     MD055446
     C**********         EXSR      ZDATE1                                                   MD055446
     C*****ErrorFlag     IFEQ      'Y'                                                      MD055446
      *                                                                                     MD055446
     C                   MOVE      DDXDOB        BWYEAR                                     MD055446
      *                                                                                     MD055446
      ** If BWYEAR is less than or equal to 1899 or greater than or                         MD055446
      ** equal to 2245, send an error message indicating it is invalid.                     MD055446
      *                                                                                     MD055446

     C     BWYEAR        IFLE      1899                                                     MD055446
     C     BWYEAR        ORGE      2245                                                     MD055446
     C                   MOVE      'N'           DDXDOBOK
     C                   ADD       1             Idx
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)
     C                   MOVEL     'USR4157'     MsgIdXAr(Idx)
     C                   GOTO      EndVXDOB
     C                   ENDIF
 
     C                   MOVE      DDXDOB        BZDATE                                     MD055446
     C                   Z-ADD     0             BDAYNO                                     MD055446
     C                   Z-ADD     BZDATE        BZDATE                                     MD055446
     C                   MOVE      BZDATE        BZYEAR                                     MD055446
     C                   MOVEL     BZDATE        BZDAY                                      MD055446
     C                   MOVE      BZDATE        BZWRK4                                     MD055446
     C                   MOVEL     BZWRK4        BZMTH                                      MD055446
      *                                                                                     MD055446
     C**********         MOVE      ZDATEA        BRXDOB                                     MD055446
 
      *                                                                                     MD055446
      ** Ensure month is valid.                                                             MD055446
      *                                                                                     MD055446
     C     BZMTH         COMP      0                                    6666                MD055446
     C  N66BZMTH         COMP      12                                 66                    MD055446
     C     *IN66         IFEQ      '1'                                                      MD055446
     C                   MOVE      'N'           DDXDOBOK                                   MD055446
     C                   ADD       1             Idx                                        MD055446
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)                             MD055446
     C                   MOVEL     'USR4157'     MsgIdXAr(Idx)                              MD055446
     C                   GOTO      EndVXDOB                                                 MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
      ** Check for 30 days month.                                                           MD055446
      *                                                                                     MD055446
     C     BZMTH         COMP      4                                      67                MD055446
     C  N67BZMTH         COMP      6                                      67                MD055446
     C  N67BZMTH         COMP      9                                      67                MD055446
     C  N67BZMTH         COMP      11                                     67                MD055446
      *                                                                                     MD055446
      ** Ensure Day is valid                                                                MD055446
      *                                                                                     MD055446
     C     BZDAY         COMP      0                                    6666                MD055446
      *                                                                                     MD055446
     C     *IN67         IFEQ      '1'                                                      MD055446
     C     *IN66         ANDEQ     '0'                                                      MD055446
     C     BZDAY         COMP      30                                 66                    MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
     C     *IN67         IFEQ      '0'                                                      MD055446
     C     *IN66         ANDEQ     '0'                                                      MD055446
     C     BZDAY         COMP      31                                 66                    MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
     C     *IN66         IFEQ      '1'                                                      MD055446
     C                   MOVE      'N'           DDXDOBOK                                   MD055446
     C                   ADD       1             Idx                                        MD055446
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)                             MD055446
     C                   MOVEL     'USR4157'     MsgIdXAr(Idx)                              MD055446
     C                   GOTO      EndVXDOB                                                 MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
      ** Check for leap year and February.                                                  MD055446
      *                                                                                     MD055446
     C     BZYEAR        ADD       28            BZYEAR                                     MD055446
     C     BZYEAR        DIV       4             BZLYR                                      MD055446
     C                   MVR                     BZLY                     68                MD055446
     C     BZMTH         COMP      2                                  70  69                MD055446
      *                                                                                     MD055446
      ** If February, further validate day.                                                 MD055446
      *                                                                                     MD055446
     C     *IN68         IFEQ      '0'                                                      MD055446
     C     *IN69         ANDEQ     '1'                                                      MD055446
     C     BZDAY         COMP      28                                 66                    MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
     C     *IN68         IFEQ      '1'                                                      MD055446
     C     *IN69         ANDEQ     '1'                                                      MD055446
     C     BZDAY         COMP      29                                 66                    MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
     C     *IN66         IFEQ      '1'                                                      MD055446
     C                   MOVE      'N'           DDXDOBOK                                   MD055446
     C                   ADD       1             Idx                                        MD055446
     C                   MOVEL     ErrFldNam     FldNamXAr(Idx)                             MD055446
     C                   MOVEL     'USR4157'     MsgIdXAr(Idx)                              MD055446
     C                   GOTO      EndVXDOB                                                 MD055446
     C                   ENDIF                                                              MD055446
      *                                                                                     MD055446
     C                   EVAL      BRXDOB = 0                                               MD055446
     C                   MOVE      DDXDOB        BRXDOB                                     MD055446
      *                                                                                     MD055446
     C                   ENDIF
 
     C     EndVXDOB      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1 - Validate & convert date to a day number             *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEA            6
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
 
     C                   ENDSR
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
      ** Other parms
      *
      ** Party Date Of Birth - screen format
      ** Party BRT Indicator
     C**********         PARM                    DDXDOB            6                        MD055446
     C                   PARM                    DDXDOB            8                        MD055446
     C                   PARM                    DDXBRT            1
      *
      ** Party Name
     C                   PARM                    DDXNAM           23
      *
      ** Date Format
     C                   PARM                    BJDFIN            1
      *                                                                                       CRE007
      ** Acount Holder Type                                                                   CRE007
     C                   PARM                    DDAHLT            1                          CRE007
      *
      ** Error Field Name
     C                   PARM                    ErrFldNam         6
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Party Date Of Birth - file format
     C                   PARM                    BRXDOB
      *
      ** Post Code Field 2 - OK
     C                   PARM                    DDXDOBOK          1
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
**  BZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN                                        MD055446
0366073110961461                                                                            MD055446
**  BZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                                          MD055446
000031059090120151181212243273304334365                                                     MD055446
