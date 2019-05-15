     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Miads MM Validate CD Holder')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVCDHOLD - Validate CD Holder                               *
      *                                                               *
      *  Function:  This module validates the CD Holder field of      *
      *             a Money Market deal.                              *
      *                                                               *
      *  Component of: MMVALIDATE - Money Market validation service   *
      *                             program                           *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL033             Date 15Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002   *CREATE   Date 01Aug97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D** EXTERNAL DS FOR CUSTOMER DETAILS
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message code 1 returned as a parameter
     D @MSGID          S                   LIKE(#MsgID)
 
      ** Deals file version of CD holder returned as a parameter
     D*IKMCDH***       S              6S 0                                                    CSD027
     D IKMCDH          S              6A                                                      CSD027
 
      ** Deal type received as parameter
     D DDTYPE          S              2A
 
      ** CD Holder received as parameter
     D DDCDCH          S             10A
 
      ** Key field for access program
     D @KEY1           S             10A
 
      ** Key status for access program
     D @KYST           S              7A
 
      ** Deal customer number received as a parameter
     D*IKCNUM***       S              6S 0                                                    CSD027
     D IKCNUM          S              6A                                                      CSD027
 
      ** Numeric version of customer number
     D*CNUM*****       S              6S 0                                                    CSD027
     D CNUM            S              6A                                                      CSD027
 
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
 
      ** Reset error found flag to prevent problems on later calls
     C                   RESET                   ErrorFound
 
     C****If*the*deal*type*is*not*CI,*and*the*holder*field*is*not*blank                       CDL033
      *                                                                                       CDL033
      **  If the deal type is not CI or CF, and the holder field is not blank                 CDL033
      *                                                                                       CDL033
     C**  it is an error.
     C     DDTYPE        IFNE      'CI'
     C     DDCDCH        ANDNE     *BLANK
     C     DDTYPE        ANDNE     'CF'                                                       CDL033
     C     DDCDCH        ANDNE     *BLANK                                                     CDL033
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0461'     @MSGID
     C*
     C**  If the holder field is not blank, continue validation.
     C                   ELSE
     C     DDCDCH        IFNE      *BLANK
     C*
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCDCH        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         OREQ      '*ERROR '
     C                   MOVEL     'MMM0462'     @MSGID
     C                   ELSE
     C                   MOVEL     DDCDCH        CUS1ST            1
     C     CUS1ST        IFEQ      '?'
     C                   MOVEL     BBCUST        DDCDCH
     C                   END
 
     C**  If no error has so far occurred on the validation of the
     C**  holder, the deal customer is valid, and the deal customer
     C**  no. is different from the holder customer no.,
     C**  this is an error.
     C                   MOVEL     BBCUST        CNUM
     C     IKCNUM        IFNE      CNUM
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0463'     @MSGID
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C**  If the field is valid, set up the customer number for output
 
     C     ErrorFound    IFEQ      'N'
     C     DDCDCH        ANDNE     *BLANKS
     C                   MOVEL     BBCUST        IKMCDH
     C                   END
     C*
     C****If*the*deal*type*is*'CI'                                                            CDL033
      *                                                                                       CDL033
      **  If the deal type is 'CI' or 'CF'                                                    CDL033
      *                                                                                       CDL033
     C**  and the holder field is blank, set up the holder customer number
     C**  for output to be the same as the deal customer number.
     C**  (Required because CD Held By field is
     C*   mandatory for MIDAS processing of CDs Issued).
     C     ErrorFound    IFEQ      'N'
     C     DDTYPE        ANDEQ     'CI'
     C     DDCDCH        ANDEQ     *BLANKS
     C     ErrorFound    OREQ      'N'                                                        CDL033
     C     DDTYPE        ANDEQ     'CF'                                                       CDL033
     C     DDCDCH        ANDEQ     *BLANKS                                                    CDL033
     C**********         Z-ADD     IKCNUM        IKMCDH                                       CSD027
     C                   EVAL      IKMCDH = IKCNUM                                            CSD027
     C                   END
 
      ** If errors, set return code
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
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
     C                   PARM                    RetCodeIn
     C                   PARM                    @MSGID
     C                   PARM                    IKMCDH
     C                   PARM                    DDTYPE
     C                   PARM                    DDCDCH
     C                   PARM                    IKCNUM
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
