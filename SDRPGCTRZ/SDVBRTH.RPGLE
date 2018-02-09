     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Date of Birth')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Additional Details Validation *
      *                                                               *
      *  SDVBRTH - Validate Date of Birth                             *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  /COPY, Customer Additional Details amendments must not be    *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD000091           Date 15May13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD079 - Enhanced Customer Maintenance API                   *
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
 
      ** Date of Birth
     D  ##DOB1         DS
     D  ##DD1                  1      2  0
     D  ##MM1                  3      4  0
     D  ##DTE1                 1      4
     D  ##CCYY                 5      8
     D  ##CC1                  5      6
     D  ##YY1                  7      8
      ** Run Date
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  SUC                   11     11
     D  DFF                   12     12
     D  MBIN                  13     13
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Midas Work Date
     D  WUWMDT         S              5  0 Inz(*Zeros)
      ** Run Day Number
     D  WURDNB         S              5  0 Inz(*Zeros)
      ** Date format flag
     D  WUDFF          S              1    Inz(*Blanks)
      ** Work Converted Date
     D  WUWCDT         S              6  0 Inz(*Zeros)
      ** Work Alpha Date
     D  WUWADT         S              7    Inz(*Blanks)
      ** Work Screen Date
     D  WUWSDT         S              6  0 Inz(*Zeros)
      ** Work File Date
     D  WUWFDT         S              5  0 Inz(*Zeros)
      ** Midas Run Date
     D  WUMRDT         S              7    Inz(*Blanks)
      ** Set Up Complete
     D  WUSUC          S              1    Inz(*Blanks)
      ** Multi-branching Indicator
     D  WUMBIN         S              1    Inz(*Blanks)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Work variables
     D WQ0010          S              7A
     D WQ0011          S              6P 0
     D WQ0012          S              1A
     D WQ0013          S              5P 0
     D W0RTN           S              7A
     D W0CLPG          S             10A
     D ADBRTH          S              5P 0
     D ADBRT1          S              6A
     D ADBRT2          S              2A
     D DDBRTH          S              8A
     D DDBRTHOK        S              1A
     D ##YY2           S              2P 0
     D ZLYR            S              2P 0
     D ZLY             S              1P 0
     D WKMM2           S              2P 0
     D ##DATE          S              6A
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
     C                   Z-ADD     0             WIdx
 
      ** VALIDATION
 
      ** Check Date of Birth is valid
     C     DDBRTH        IFNE      *BLANK
     C                   MOVEL     DDBRTH        ##DOB1
      ** For the format MMDDYY swap around DD and MM fields in DS ##DOB1
     C     WUDFF         IFEQ      'M'
     C                   MOVE      ##DD1         WKMM2
     C                   MOVE      ##MM1         ##DD1
     C                   MOVE      WKMM2         ##MM1
     C                   ENDIF
     C                   EXSR      CHKDAT
     C     *IN90         IFEQ      '0'
     C                   MOVEL     ##DTE1        ##DATE
     C                   MOVE      ##YY1         ##DATE
     C     ##CCYY        IFGE      '1972'
     C     ##CCYY        ANDLE     '2071'
     C                   MOVEL     ##DATE        WUWSDT
      ** Convert Date of Birth to Midas Day Number
     C                   CALL      'ZDATE1'                             90
     C     W0RTN         PARM      W0RTN         WQ0010
     C     WUWSDT        PARM      WUWSDT        WQ0011
     C     WUDFF         PARM      WUDFF         WQ0012
     C     WUWFDT        PARM      *ZERO         WQ0013
 
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'Y2U0032'     W0RTN
     C                   MOVEL     *BLANKS       W0CLPG
     C                   MOVEL     'ZDATE1'      W0CLPG
      ** Send message '*Error occured on CALL...'
     C                   EVAL      DDBRTHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRTH   '
     C                   EVAL      MsgIdXAr(Idx) = 'Y2U0032'
     C**********         EVAL      MsgDtaXAr(Idx)= W0CLPG                                   MD000091
     C                   EVAL      BLen = %Len(%Trim(W0CLPG))                               MD000091
     C                   EVAL      MsgDtaXAr(IDX) = LenStr +%TRIM(W0CLPG)                   MD000091
     C                   END
      ** Date of Birth not valid
     C     W0RTN         IFEQ      '*ERROR*'
     C                   EVAL      DDBRTHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRTH   '
     C                   EVAL      MsgIdXAr(Idx) = 'USR1962'
 
     C                   ELSE
 
     C                   Z-ADD     WUWFDT        ADBRTH
     C                   MOVEL     ##DATE        ADBRT1
     C                   MOVEL     ##CC1         ADBRT2
     C                   END
     C                   ELSE
     C                   Z-ADD     *ZERO         ADBRTH
     C                   MOVEL     ##DATE        ADBRT1
     C                   MOVEL     ##CC1         ADBRT2
     C                   END
     C                   END
     C                   ELSE
 
     C                   Z-ADD     *ZERO         ADBRTH
     C                   MOVEL     *BLANKS       ADBRT1
     C                   MOVEL     *BLANKS       ADBRT2
     C                   END
 
      ** RETURN
 
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** INPUTS
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** Other parms
 
      ** Field(s) requiring validation
     C                   PARM                    DDBRTH
 
      ** OUTPUTS
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Date of Birth
     C                   PARM                    DDBRTHOK
     C                   PARM                    ADBRTH
     C                   PARM                    ADBRT1
     C                   PARM                    ADBRT2
 
      * Get Rundate - Rundate  *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          WUMRDT
     C                   MOVE      RDNB          WURDNB
     C                   MOVE      SUC           WUSUC
     C                   MOVE      DFF           WUDFF
     C                   MOVE      MBIN          WUMBIN
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      * CHKDAT - Check Date                                           *
      *****************************************************************
     C     CHKDAT        BEGSR
 
     C                   SETOFF                                       90
     C     ##DD1         IFGT      31
     C     ##DD1         ORLE      0
     C     ##MM1         ORGT      12
     C     ##MM1         ORLE      0
     C     ##CC1         ORLT      '19'
     C     ##CC1         ORGT      '20'
     C                   SETON                                        90
     C                   END
 
      ** Check for 30 day months, bypass if error
     C     ##MM1         IFEQ      4
     C     ##MM1         OREQ      6
     C     ##MM1         OREQ      9
     C     ##MM1         OREQ      11
 
     C     ##DD1         IFGT      30
     C                   SETON                                        90
     C                   END
     C                   END
 
      ** Check for Leap Year: Remainder will be zero if it is a leap yr
     C                   MOVE      ##YY1         ##YY2
     C     ##YY2         ADD       28            ##YY2
     C     ##YY2         DIV       4             ZLYR
     C                   MVR                     ZLY
 
      ** If February further validate day
     C     ##MM1         IFEQ      2
 
      ** Invalid if greater than 28 and not a leap year
     C     ZLY           IFGT      0
     C     ##DD1         ANDGT     28
     C                   SETON                                        90
     C                   END
 
     C** Invalid if greater than 29 and a leap year - bypass if error
     C     ZLY           IFEQ      0
     C     ##DD1         ANDGT     29
     C                   SETON                                        90
     C                   END
     C                   END
 
      ** For the format MMDDYY swap around DD and MM fields in DS ##DOB1
     C     WUDFF         IFEQ      'M'
     C                   MOVE      ##DD1         WKMM2
     C                   MOVE      ##MM1         ##DD1
     C                   MOVE      WKMM2         ##MM1
     C                   ENDIF
     C     *IN90         IFEQ      '1'
     C                   EVAL      DDBRTHOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDBRTH   '
     C                   EVAL      MsgIdXAr(Idx) =  'USR1962'
     C                   END
 
     C     CDTEND        ENDSR
      *****************************************************************
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
