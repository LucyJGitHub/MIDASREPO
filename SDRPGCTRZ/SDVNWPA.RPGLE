     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(SDCBRTLR) TOFILE(SDCBRTL0) SHARE(*NO)            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate New Participants')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Customer Details Validation   *
      *                                                               *
      *  SDVNWPA  - Validate New Participants, Base Rate Tax          *
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
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CRE007             Date 01Mar01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP034  *CREATE    Date 01Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055446 - There are parties and fields missing from the BRT *	
      *             details tab in Customer Input plus date of birth  *	
      *             issues.                                           *	
      *           - Recompile over changes in SDCBRTPD.               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE007 - Basic rate tax 2001 - Recompile                     *
      *  CAP034 - Conversion of SD inputs into modular structure      *
      *           to use as APIs.                                     *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+


     FSDCBRTLR  IF   E           K DISK    INFSR(*PSSR)


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

      ** Customer Base Rate Tax in screen format
     D CuBrt         E DS                  EXTNAME(SDCUBRPD)


     D NewNamArr       S             23    DIM(5)
     D OldNamArr       S             23    DIM(5)
     D ChgNamArr       S              1    DIM(5)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

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

      ** If called from screen input program
      ** check for name change on participants
      ** if found, set prompt flags for on screen processing

     C                   EXSR      CNEWP
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** Check for Name Change on Parties
      *****************************************************************
     C     CNEWP         BEGSR

      * If a participant name is entered which is not on file at a
      * relative position for which a participant name does exist on file
      * the user will be prompted to confirm whether this is a new
      * participant or a name change (e.g. marriage)

      * The prompt(s) require a redisplay of Base Rate Tax screen(s)
      * and only offered once all other details are validated successfully


      * If back office processing and
      * and no errors have resulted from earlier validation
     C     SINVAL        IFEQ      '1'
     C     Idx           ANDEQ     0


      * Move file particpant names into array
     C                   MOVE      DDCUSN        XCNUM
     C                   MOVEA     *BLANKS       OldNamArr
     C     XCNUM         CHAIN     SDCBRTLR                           99
     C     *IN99         IFEQ      '0'
     C                   MOVE      H1NAME        OldNamArr(1)
     C                   MOVE      H2NAME        OldNamArr(2)
     C                   MOVE      H3NAME        OldNamArr(3)
     C                   MOVE      H4NAME        OldNamArr(4)
     C                   MOVE      H5NAME        OldNamArr(5)
     C                   ENDIF

      * Move screen participant names into array
     C                   MOVE      DD1NAM        NewNamArr(1)
     C                   MOVE      DD2NAM        NewNamArr(2)
     C                   MOVE      DD3NAM        NewNamArr(3)
     C                   MOVE      DD4NAM        NewNamArr(4)
     C                   MOVE      DD5NAM        NewNamArr(5)

      ** Initialise party status array
     C                   MOVE      'NNNNN'       ChgNamArr

      * For each of the five screen participant postions
     C                   Z-ADD     1             Z                 2 0
     C     Z             DOUEQ     6
     C                   MOVEA     NewNamArr(Z)  NEW              23

      * If a participant name entered at this position on screen
     C     NEW           IFNE      *BLANKS

      * and any name exists at the corresponding position on file
     C     OldNamArr(Z)  IFNE      *BLANKS

      * is the screen name one of names on file?
     C     NEW           LOOKUP    OldNamArr                              90

      * if it is not, store in parameter that the user must be prompted
     C     *IN90         IFEQ      '0'
     C                   MOVE      'P'           ChgNamArr(Z)
     C                   ENDIF

      * otherwise (i.e. the participant position on file is blank)
     C                   ELSE

      * is the screen participant name one of names on file?
     C     NEW           LOOKUP    OldNamArr                              90

      * if it is not, store in parameter that this is a new participant
     C     *IN90         IFEQ      '0'
     C                   MOVE      'Y'           ChgNamArr(Z)
     C                   ENDIF
      *
     C                   ENDIF

      * otherwise (i.e. the participant position on screen is blank)
     C                   ELSE

      * store in parameter no participant at this position
     C                   MOVE      *BLANKS       ChgNamArr(Z)
     C                   ENDIF

     C                   ADD       1             Z

     C                   ENDDO

     C                   ENDIF

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
      ** Customer Number (6A)
     C                   PARM                    DDCUSN            6
      *
      ** Base Rate Tax screen details
     C                   PARM                    CuBrt
      *
      ** Screen validation
     C                   PARM                    SinVal            1
      *
      ** Screen validation error count
     C                   PARM                    Idx               3 0
      *
      * OUTPUTS
      *
      ** Changed Party Names Array
     C                   PARM                    ChgNamArr
      *
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
