     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2021')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FN String end return 1st blank pos in string')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  A1008010 - Midas FN String end return 1st blank pos in string*
      *                                                               *
      *  Function:  This module receives a string (character field)   *
      *             of up to 8Kb, and returns the position of         *
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
      *  Calls by:  A1008009                                          *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BA1008 - Replication of Trades to consolidated branches      *
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
      *
      ** Array to scan string
      *
     D StringArry      S              1A   DIM(8000)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** String
      *
     D String          S           8000A
      *
      ** The length of the string being scanned
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possible reinstate
      ** at a later date.)
      *
     D StringLen       S              5P 0
      *
      ** Position in string
      ** (Integer variable could not be used because of compatibility
      ** problems with supporting earlier releases.  Possible reinstate
      ** at a later date.)
      *
     D Position        S              5P 0
      *
      ** Array index
      *
     D Idx             S              5P 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** If the received value of string length is greater than the
      ** maximum possible string length, end in error
      *
     C                   IF        StringLen > 8000
     C                   EVAL      RetCodeIn = 'ErrTooLong'
     C                   EXSR      *pssr
     C                   ENDIF
      *
      ** +--- Note on implementation ---------------------------------+
      ** ¦                                                            ¦
      ** ¦ This function has been implemented using a search          ¦
      ** ¦ backwards through an array, rather than by use of RPG's    ¦
      ** ¦ built-in opcode CHECKR (Check right).  This is because     ¦
      ** ¦ CHECKR proved to be incredibly slow, and an array search is¦
      ** ¦ faster. It's possible that the array search could be       ¦
      ** ¦ replaced with a suitable built-in function at a later date.¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Put the received field into the array
      *
     C                   MOVEA     String        StringArry
      *
      ** Set the starting index to the received value of the string
      ** length
      *
     C                   EVAL      Idx = StringLen
      *
      ** Find the first nonblank character, starting from the right
      *
     C                   DOW       Idx > 0 AND StringArry(Idx) = *blank

     C                   EVAL      Idx = Idx - 1

     C                   ENDDO
      *
      ** Add one, to represent the position of the first significant
      ** blank
      *
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
      *
      ** Incoming return code (10A, returned to caller)
      *
     C                   PARM                    RetCodeIn
      *
      ** Position of first significant blank in string (5,0P, returned
      ** to caller)
      *
     C                   PARM                    Position
      *
      ** String (4096A, from caller)
      *
     C                   PARM                    String
      *
      ** Length of string (5,0P, from caller)
      *
     C                   PARM                    StringLen
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2021
