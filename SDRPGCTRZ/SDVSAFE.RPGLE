     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Validate Safe Details')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Safe Details         *
      *                                 Validation                    *
      *                                                               *
      *  SDVSAFE - Validate Safe Details                              *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *    /COPY, Customer Safe details amendments must not be        *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSD079  *CREATE    Date 05Feb07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D DATEN           S              6  0
     D DATEA           S              6A
      ** Parameters for ZA0840
     D PRetCode        S                   LIKE(ReturnCode)
     D PAlpha          S             16A
     D PIDP            S              3  0
     D PIINT           S              3  0
     D PIMTID          S              1A
     D POErrCde        S              1  0
     D POAmount        S             15  0
     D BNDCSP          S              1A
      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D DatFmt          S              1A
     D ErrorFlag       S              1A
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
      ** Parameters
     D DDSFNX          S              6A
     D DDSFSX          S              2A
     D DDSFIX          S              6A
     D FldNam1         S             10A
     D FldNam2         S             10A
     D FldNam3         S             10A
     D DDSFNXOK        S              1A
     D DDSFSXOK        S              1A
     D DDSFIXOK        S              1A
     D SFSFIX          S              5  0
 
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
 
      ** Validation
      ** Validate Safe Number
     C     DDSFNX        IFEQ      *BLANKS
     C     DDSFSX        IFNE      *BLANKS
     C     DDSFIX        ORNE      *BLANKS
     C                   EVAL      DDSFNXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNam1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1113'
     C                   ENDIF
     C                   ENDIF
 
     C     DDSFNX        IFNE      *BLANKS
      **   Move screen fields in data structure working field
     C                   Z-ADD     0             PIDP
     C                   Z-ADD     6             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDSFNX        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
     C                   MOVE      '.'           BNDCSP
 
     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP
      ** Invalid Safe Number
     C     POErrCde      IFNE      *ZEROS
     C                   EVAL      DDSFNXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNam1
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1114'
     C                   ELSE
     C                   MOVE      PAlpha        DDSFNX
     C                   ENDIF
      ** Validate Size
     C     DDSFSX        IFNE      *BLANKS
      **   Move screen fields in data structure working field
     C                   Z-ADD     0             PIDP
     C                   Z-ADD     2             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDSFSX        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
     C                   MOVE      '.'           BNDCSP
 
     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP
      ** Invalid Size
     C     POErrCde      IFNE      *ZEROS
     C                   EVAL      DDSFSXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNam2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1116'
     C                   ELSE
     C                   MOVE      PAlpha        DDSFNX
     C                   ENDIF
     C                   ELSE
     C                   EVAL      DDSFSXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNam2
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1115'
     C                   ENDIF
      ** Validate Safe Rented Date
     C     DDSFIX        IFNE      *BLANKS
      ** The date is invalid if the input date is not equal to a
      ** Numeric field transferred in an alphanumeric field
     C                   MOVE      DDSFIX        DATEN
     C                   MOVE      DATEN         DATEA
     C     DDSFIX        IFNE      DATEA
     C                   EVAL      DDSFIXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNam3
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1118'
     C                   ELSE
     C                   MOVE      DDSFIX        DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZEROS        DaynoOut
     C                   PARM      'D'           DatFmt
     C                   PARM      *BLANKS       ErrorFlag
 
      ** Invalid date
      ** Invalid issued date 1
     C     ErrorFlag     IFEQ      'Y'
     C                   EVAL      DDSFIXOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = FldNam3
     C                   EVAL      MsgIdXAr(Idx) = 'LZP1118'
     C                   ELSE
     C                   MOVE      DaynoOut      SFSFIX
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Return
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      ** Inputs
      ** Return Code
     C                   PARM                    RetCodeIn
      ** Other parms
      ** Field(s) requiring validation
      ** Safe No
     C                   PARM                    DDSFNX
      ** Size
     C                   PARM                    DDSFSX
      ** Safe Rent Date
     C                   PARM                    DDSFIX
      ** Field Name 1
     C                   PARM                    FldNam1
      ** Field Name 2
     C                   PARM                    FldNam2
      ** Field Name 3
     C                   PARM                    FldNam3
      ** Outputs
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Safe No - OK
     C                   PARM                    DDSFNXOK
      ** Size - OK
     C                   PARM                    DDSFSXOK
      ** Safe Rent Date - OK
     C                   PARM                    DDSFIXOK
      ** Safe Rent Date
     C                   PARM                    SFSFIX
 
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
(c) Finastra International Limited 2006
