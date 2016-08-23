     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility review fields validation')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFCRFVAL - Facility Review Fields Validation                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP071             Date 28Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as API's.                                       *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 5
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
 
      ** Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Facility Type
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * CLEAR OUTPUTS
 
     C                   MOVE      'Y'           R#CSSNok
     C                   MOVE      'Y'           R#FACTok
     C                   MOVE      'Y'           R#FCNOok
     C                   MOVE      *ZEROS        R_CNUM
     C                   MOVE      *ZEROS        R_FACT
     C                   MOVE      *ZEROS        R_FCNO
 
     C                   MOVE      *BLANK        FldNameArr
     C                   MOVE      *BLANK        MsgIdArr
     C                   MOVE      *BLANK        MsgDtaArr
     C                   Z-ADD     0             Ix
 
      ** Validate customer
 
     C     R#CSSN        IFNE      *BLANKS
     C                   EXSR      VLCSSN
     C                   ENDIF
 
      ** Validate facility type
 
     C     R#FACT        IFNE      *BLANKS
     C                   EXSR      VLFACT
     C                   ENDIF
 
      ** Validate facility number
 
     C     R#FCNO        IFNE      *BLANKS
     C                   EXSR      VLFCNO
     C                   ENDIF
 
     C                   RETURN
 
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Validate customer
      ***********************************************************
     C     VLCSSN        BEGSR
 
      ** Customer number may refer to a valid customer
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      R#CSSN        @KEY1            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     *BLANK        R#CSSN
     C                   MOVEL     BBCUST        R#CSSN
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     R#CSSN        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     6             ZADIG
     C                   EXSR      ZALIGN2
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           R#CSSNok
     C                   ADD       1             Ix
     C                   MOVEL     'R#CSSN    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0003'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        R_CNUM
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Validate facility type
      ***********************************************************
     C     VLFACT        BEGSR
 
      ** Facility type may refer to a valid facility type
 
     C                   CALL      'AOFACTR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      R#FACT        @FKEY             3
     C     SDFACT        PARM      SDFACT        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     AMFCTY        R#FACT
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     R#FACT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      ZALIGN2
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           R#FACTok
     C                   ADD       1             Ix
     C                   MOVEL     'R#FACT    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0004'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        R_FACT
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
      /SPACE 5
      ***********************************************************
      ** Validate facility number
      ***********************************************************
     C     VLFCNO        BEGSR
 
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     R#FCNO        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     2             ZADIG
     C                   EXSR      ZALIGN2
 
     C     ZALIGNok      IFNE      'Y'
     C                   MOVE      'N'           R#FCNOok
     C                   ADD       1             Ix
     C                   MOVEL     'R#FCNO    '  FldNameArr(Ix)
     C                   MOVEL     'LEF0005'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        R_FCNO
     C                   ENDIF
 
     C                   ENDSR
      ***********************************************************
     C/SPACE 5
      *****************************************************************
     C     ZALIGN2       BEGSR
     C                   CALLB     'ZALIGN2'
     C                   PARM      'Y'           ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             2 0
     C                   PARM                    ZADIG             2 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
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
 
      * Customer, facility type and facility number
     C                   PARM                    R#CSSN           10
     C                   PARM                    R#FACT            3
     C                   PARM                    R#FCNO            2
      *
      * OUTPUTS
 
      * Customer, facility type and facility number OK indicators
     C                   PARM                    R#CSSNok          1
     C                   PARM                    R#FACTok          1
     C                   PARM                    R#FCNOok          1
 
      * Customer number, facility type and facility number
     C                   PARM                    R_CNUM            6
     C                   PARM                    R_FACT            3
     C                   PARM                    R_FCNO            2
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
