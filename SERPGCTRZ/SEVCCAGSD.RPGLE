     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate CCAGSD Agreed Settlement Date')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVCCAGSD  - Validate Agreed Settlement Date                 *
      *                                                               *
      *  Function:  This module receives a parameter containing an    *
      *             agreed settlement date, and confirms whether it   *
      *             is a valid date or not.                           *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 ULX603  *CREATE    Date 15Dec99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX603 - API Luxembourg - Function SETRAD                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      ** External data structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #6LXAGSD        S              6A
     D WWAGSD          S              5S 0
     D #1ISSD          S              5S 0
     D #1MATY          S              5S 0
     D #1TDDT          S              5S 0
     D #1TDVD          S              5S 0
 
      ** Define parameters for call module
     D ZALIGNok        S              1A
 
      ** Define output parameters
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D DateIn          S              6A
     D Dayno           S              5P 0
 
     D ZDAYN           S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
     C                   RESET                   ZALIGNok
      *
      ** If agreed settlement date is blanks, trade value date by default
      *
     C     #6LXAGSD      IFEQ      *BLANKS
     C                   CALLB     'ZDATE2'
     C                   PARM      #1TDVD        ZDAYN
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
     C                   MOVE      ZDATE         #6LXAGSD
     C                   ENDIF
      *
      ** Validate field
      *
     C                   MOVE      *OFF          *IN99
     C                   TESTN                   #6LXAGSD             99
     C     *IN99         IFNE      *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER05001'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  #6LXAGSD      ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Input is not valid
      *
     C     ZALIGNok      IFEQ      'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER05001'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Verify if the agreed settlement date is valid
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      #6LXAGSD      DateIn
     C                   PARM      *ZEROS        Dayno
     C                   PARM                    Bjdfin
     C                   PARM                    ErrorFound
      *
      ** The agreed settlement date is not valid
      *
     C     ErrorFound    IFEQ      'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER05002'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** The Midas date is placed in a work field
      *
     C                   Z-ADD     Dayno         WWAGSD
      *
      ** Agreed Settlement Date must be after the trade date
      *
     C     WWAGSD        IFLT      #1TDDT
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER05003'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** Agreed Settlement Date must be before the maturity date of the security
      ** and after the issue date of the security.
      *
     C     #1MATY        IFNE      *ZEROS
     C     #1ISSD        ANDNE     *ZEROS
      *
     C     WWAGSD        IFGE      #1MATY
     C     WWAGSD        ORLT      #1ISSD
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'ER05004'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #6LXAGSD
     C                   PARM                    WWAGSD
     C                   PARM                    #1ISSD
     C                   PARM                    #1MATY
     C                   PARM                    #1TDDT
     C                   PARM                    #1TDVD
      *
      ** Access Bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*BLANKS'     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
