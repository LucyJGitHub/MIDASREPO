     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA String end return 1st blank pos in string')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZASTREND - Return first blank position in a string           *
      *                                                               *
      *  Function:  This module receives a string (character field)   *
      *             of up to 4Kb, and returns the position of         *
      *             the first blank after any nonblank content: ie    *
      *             LAST blank, starting from the right.              *
      *                                                               *
      *  Possible return codes                                        *
      *  =====================                                        *
      *                                                               *
      *  ErrTooLong - The String Length parameter contains a value    *
      *               greater than the largest possible value for     *
      *               the string to be searched (4096)                *
      *                                                               *
      *  Component of: ZASTRING - ZA module string handling service   *
      *                           program                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT039             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 16Sep98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           Amendment done to accommodate longer data           *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *  CAP004 - Fix applied during APIs phase 3 development:        *
      *           the array index field, Idx, is 3,0P; the StringLen  *
      *           field is 5,0P.  They need to be the same.           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
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
 
      ** Array to scan string
     D*StringArry******S              1A   DIM(%LEN(String))
     D*StringArry      S              1A   DIM(4096)                                          CIR003
     D*StringArry      S              1A   DIM(6000)                                   CIR003 CFT039
     D StringArry      S              1A   DIM(12000)                                         CFT039
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** String
     D*String***       S           4096A                                                      CIR003
     D*String***       S           6000A                                               CIR003 CFT039
     D String          S          12000A                                                      CFT039
 
      ** The length of the string being scanned
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possible reinstate at
      ** a later date.)
     D*StringLen*******S              5I 0
     D*StringLen       S              5P 0                                                    CFT039
     D StringLen       S              9P 0                                                    CFT039
 
      ** Position in string
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possible reinstate at
      ** a later date.)
     D*Position********S              5I 0
     D Position        S              5P 0
 
      ** Array index
     D*Idx*************S              5I 0
     D*Idx*************S              3P 0                                      CAP004
     D Idx             S              5P 0                                      CAP004
 
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
 
      ** If the received value of string length is greater than the
      ** maximum possible string length, end in error
     C*********          IF        StringLen > %LEN(String)
     C**********         IF        StringLen > 4096                                           CIR003
     C**********         IF        StringLen > 6000                                    CIR003 CFT039
     C                   IF        StringLen > 12000                                          CFT039
     C                   EVAL      RetCodeIn = 'ErrTooLong'
     C                   EXSR      *pssr
     C                   ENDIF
 
      ** +--- Note on implementation -------------------------------------+
      ** ¦                                                                ¦
      ** ¦ This function has been implemented using a search              ¦
      ** ¦ backwards through an array, rather than by use of RPG's        ¦
      ** ¦ built-in opcode CHECKR (Check right).  This is because CHECKR  ¦
      ** ¦ proved to be incredibly slow, and an array search is faster.   ¦
      ** ¦ It's possible that the array search could be replaced with a   ¦
      ** ¦ suitable built-in function at a later date.                    ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Put the received field into the array
     C                   MOVEA     String        StringArry
 
      ** Set the starting index to the received value of the string length
     C                   EVAL      Idx = StringLen
 
      ** Find the first nonblank character, starting from the right
     C                   DOW       Idx > 0 AND StringArry(Idx) = *blank
 
     C                   EVAL      Idx = Idx - 1
 
     C                   ENDDO
 
      ** Add one, to represent the position of the first significant blank
     C                   EVAL      Position = Idx + 1
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A, returned to caller)
     C                   PARM                    RetCodeIn
      ***Position*of*first*significant*blank*in*string*(5,0I,*returned*to***
      ***caller)************************************************************
      ** Position of first significant blank in string (5,0P, returned to
      ** caller)
     C                   PARM                    Position
      ** String (4096A, from caller)
     C                   PARM                    String
      ***Length*of*string*(5,0I,*from*caller)*******************************
      ***Length*of*string*(5,0P,*from*caller)**************************                       CFT039
      ** Length of string (9,0P, from caller)                                                 CFT039
     C                   PARM                    StringLen
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
