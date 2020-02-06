     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Risk Value Factor and Sign')         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRVRISKVL - Validation of Risk Value Factor and Sign         *
      *                                                               *
      *  Function:  This program validates risk value factor and      *
      *             sign.                                             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG22478           Date 27Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 224114             Date 05Jan04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22478 - Field error during authorization. Applied 245692  *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *  224114 - Risk Value Factor must not be Mandatory             *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Risk Value Factor and Sign passed as a parameter
     D SRKVL           S             12
     D SRKSN           S              1
 
      ** Message Ids returned to calling program
     D Msgid1          S                   Like(#Msgid)
     D Msgid2          S                   Like(#Msgid)
 
      ** Field passed to ZALIGN for validation
     D ZFIELD          S             16
 
      ** ZALIGN validation indicator
     D ZALIGNok        S              1
 
      ** Decimal places field passed to ZALIGN
     D ZADEC           S              1  0
 
      ** Digital places field passed to ZALIGN
     D ZADIG           S              2  0
 
      ** Buy/Sell Indicator
     D FRBYSL          S              1
 
     D ContRate        S             11  7
     D RefrRate        S             11  7
 
      ** Our/Their Contract Rates
     D FRURTSP         S             11  7
     D FRTRTSP         S             11  7
 
      ** Our/Their Base Rates
     D FRUBRTE         S             11  7
     D FRTBRTE         S             11  7
 
     D WkNetR          S             11  7
     D WkNTRt          S             11  7
 
      ** Validated Risk Value Factor and Sign
     D FRRKVL          S             11  7
 
      ** Decimal separator                                                                    245692
     D BNDCSP          S              1A                                                      245692
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
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
 
      ** Perform Initialisations
 
     C                   EXSR      SrInit
 
      ** Call subroutine that performs validation
 
     C                   EXSR      SrVald
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVald - Validate Risk Value Factor and Sign                 *
      *                                                               *
      *****************************************************************
     C     SrVald        BEGSR
 
      ** Validate Risk Value Factor: mandatory and must be numeric
 
     C**********         IF        SRKVL = *BLANK                                             224114
     C**********         EVAL      ErrorFound = 'Y'                                           224114
     C**********         EVAL      Msgid1 = 'MMA1308'                                         224114
     C**********         ELSE                                                                 224114
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         Z-ADD     7             ZADEC                                        245692
     C**********         Z-ADD     4             ZADIG                                        245692
     C**********         MOVE      SRKVL         ZFIELD                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVEL     SRKVL         @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
     C                   MOVE      'N'           @@MTID                                       245692
 
     C**********         CALLB     'ZALIGN'                                                   245692
     C**********         PARM                    ZALIGNok                                     245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM                    ZADEC                                        245692
     C**********         PARM                    ZADIG                                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
 
     C**********         IF        ZALIGNok = 'Y'                                             245692
     C     @@ERCD        IFEQ      0                                                          245692
     C**********         MOVE      ZFIELD        FRRKVL                                       245692
     C                   MOVE      @@AMT         FRRKVL                                       245692
     C                   ELSE
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      Msgid1 = 'MMA1308'
     C                   ENDIF
 
     C**********         ENDIF                                                                224114
 
      ** Validate Risk Value Sign: must be '+' or '-'
 
     C                   IF        SRKSN = *BLANKS
     C                   EVAL      SRKSN = '+'
     C                   ELSE
     C                   IF        SRKSN <> '+' AND SRKSN <> '-'
     C                   EVAL      Msgid2 = 'MMA1309'
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** If Risk Value Factor and Sign are valid, compute and check for the
      ** Net Treasury Rate
 
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ELSE
     C                   EXSR      SrNTRC
     C                   IF        WkNTRt <= 0
     C                   EVAL      Msgid1 = 'MMA1310'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNTRC - Computation for Net Treasury Rate                   *
      *                                                               *
      *****************************************************************
     C     SrNTRC        BEGSR
 
     C                   IF        FRBYSL = 'B'
 
     C                   IF        SRKSN = '+'
     C                   EVAL      WkNetR = FRURTSP + FRRKVL
     C                   ELSE
     C                   EVAL      WkNetR = FRURTSP - FRRKVL
     C                   ENDIF
 
     C                   EVAL      WkNTRt = WkNetR
 
     C                   ELSE
 
     C                   IF        SRKSN = '+'
     C                   EVAL      WkNetR = FRTRTSP + FRRKVL
     C                   ELSE
     C                   EVAL      WkNetR = FRTRTSP - FRRKVL
     C                   ENDIF
 
     C                   EVAL      WkNTRt = WkNetR
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation subroutine                           *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
     C                   RESET                   ErrorFound
     C                   RESET                   Msgid1
     C                   RESET                   Msgid2
     C                   RESET                   RetCodeIn
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
 
     C                   IF        FRBYSL = 'B'
     C                   Z-ADD     ContRate      FRURTSP
     C                   Z-ADD     0             FRTRTSP
     C                   Z-ADD     0             FRUBRTE
     C                   Z-ADD     RefrRate      FRTBRTE
     C                   ELSE
     C                   Z-ADD     0             FRURTSP
     C                   Z-ADD     ContRate      FRTRTSP
     C                   Z-ADD     RefrRate      FRUBRTE
     C                   Z-ADD     0             FRTBRTE
     C                   ENDIF
 
     C                   ENDSR
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
 
     C     *ENTRY        PLIST
 
      ** Return code
     C                   PARM                    RetCodeIn
 
      ** Message Ids
     C                   PARM                    Msgid1
     C                   PARM                    Msgid2
 
      ** Screen fields
     C                   PARM                    SRKVL
     C                   PARM                    SRKSN
 
      ** Valid file fields
     C                   PARM                    FRBYSL
     C                   PARM                    ContRate
     C                   PARM                    RefrRate
 
      ** Validated file fields
     C                   PARM                    FRRKVL
     C                   PARM                    BNDCSP                                       245692
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
