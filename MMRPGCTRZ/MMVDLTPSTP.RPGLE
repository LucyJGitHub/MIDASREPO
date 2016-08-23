     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate deal type and subtype')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVDLTPSTP - Validate deal type and subtype                  *
      *                                                               *
      *  Function:  This module receives parameters containing        *
      *             putative deal type and subtype, and both checks   *
      *             their individual validity using the modules       *
      *             for those purposes, and checks that their         *
      *             interdependence is correct.  If everything is OK, *
      *             the 10A return code will be blank; if it is not,  *
      *             it will contain 'Error'                           *
      *                                                               *
      *  Component of: MMVALIDATE - MM validation service program     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG9827            Date 13Jan06               *
      *                 CDL038             Date 10May05               *
      *                 CDL033             Date 10Feb05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG9827- Pass CDL006 parameter                               *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CDL033 - Floating Rate CD Issued                             *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
 
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
 
      ** External data structure for Deal Subtype details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for transaction classes file                                 CDL038
     D SDTCLS        E DS                  EXTNAME(SDTCLSPD)                                  CDL038
                                                                                              CDL038
      ** External data structure for SAR details                                              CDL038
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL038
                                                                                              CDL038
      ** External data structure for access programs (short)                                  CDL038
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDL038
                                                                                              CDL038
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Deal type received as a parameter
     D DDType          S              2A
 
      ** Whether input Deal type is valid, set to Y as a default
     D DDTypeOK        S              1A
 
      ** Deal subtype received as a parameter
     D DDStyp          S              2A
 
      ** Class received as a parameter                                                        CDL038
     D DDClas          S              4A                                                      CDL038
                                                                                              CDL038
      ** Error message code 1 returned to caller (error in deal type)
     D Msgid1          S                   LIKE(#MsgID)
 
      ** Error message code 2 returned to caller (error in subtype)
     D Msgid2          S                   LIKE(#MsgID)
 
      ** Error message code 2C returned to caller (error in class)              CDL038
     D Msgid2C         S                   LIKE(#MsgID)                         CDL038
                                                                                CDL038
      ** Error message code 3 returned to caller (error in combination)
     D Msgid3          S                   LIKE(#MsgID)
                                                                                CDL006
     D**********CDL006          S              1A   IMPORT                            CDL006 BUG9827
     D CDL006          S              1A                                                     BUG9827
 
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
 
      ** Reset the error flag to prevent problems on subsequent calls
     C                   RESET                   ErrorFound
 
      ** Validate the deal type
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVDLTYPE'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgID1
     C                   PARM                    DDType
     C                   PARM                    TransType
     C                   PARM                    PActn                          CDL006
     C                   PARM                    CDL033                                       CDL033
     C                   PARM                    PWMsgID1                       CDL006
     C                   PARM                    CDL006                                      BUG9827
 
      ** If errors were detected set the flag
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      ErrorFound = 'Y'
 
      ** Set the Deal Type OK flag to N for use elsewhere in the suite
     C                   EVAL      DDTypeOK = 'N'
 
     C                   ENDIF
 
      ** Validate the subtype
     C                   RESET                   ReturnCode
     C                   CALLB     'MMVDLSTYPE'
     C                   PARM                    ReturnCode
     C                   PARM                    MsgID2
     C                   PARM                    DDStyp
     C                   PARM                    SDDLST
 
      ** If errors were detected set the flag
     C                   IF        ReturnCode <> *blanks
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
      *                                                                         CDL038
      * CLASV - CLASS VALIDATION                                                CDL038
      *                                                                         CDL038
     C     CDL038        IFEQ      'Y'                                          CDL038
     C                   EXSR      CLASV                                        CDL038
     C                   ENDIF                                                  CDL038
 
     C** The deal types/subtypes table should be checked only if the
     C** subtype and class are valid.                                           CDL038
     C***subtype*is*not*blank.******                                            CDL038
 
     C*****DDSTYP********IFNE*******BLANKS                                      CDL038
     C     MsgID2        IFEQ      *BLANK                                       CDL038
     C     MsgID2C       ANDEQ     *BLANK                                       CDL038
     C                   EXSR      ChkCombo
     C                   ENDIF
 
      ** If errors, set the return code
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * CLASV - CLASS VALIDATION                                                              CDL038
      *****************************************************************                       CDL038
     C     CLASV         BEGSR                                                                CDL038
      *                                                                                       CDL038
      ** Class must be entered                                                                CDL038
      *                                                                                       CDL038
     C     DDCLAS        IFEQ      *BLANKS                                                    CDL038
     C                   EVAL      ErrorFound = 'Y'                                           CDL038
     C                   MOVEL     'MMM0252'     MsgId2C                                      CDL038
     C                   ELSE                                                                 CDL038
      *                                                                                       CDL038
      ** Check that the class exists                                                          CDL038
      *                                                                                       CDL038
     C                   CALL      'AOTCLSR0'                                                 CDL038
     C                   PARM      *BLANKS       @RTCD             7                          CDL038
     C                   PARM      '*KEY   '     @OPTN             7                          CDL038
     C                   PARM      DDCLAS        @CLAS             4                          CDL038
     C     SDTCLS        PARM      SDTCLS        DSFDY                                        CDL038
     C     @RTCD         IFNE      *BLANKS                                                    CDL038
     C                   EVAL      ErrorFound = 'Y'                                           CDL038
     C                   MOVEL     'MMM0253'     MsgId2C                                      CDL038
   25C                   ELSE                                                                 CDL038
   25C                   MOVEL     TCCLAS        DDCLAS                                       CDL038
     C                   END                                                                  CDL038
     C                   END                                                                  CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkCombo - Check the combination of deal type and subtype     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     ChkCombo      BEGSR
 
     C**  Record must exist on FDDTSTL1
     C*
     C                   OPEN      FDDTSTL1                             65
     C     @DTSTK        CHAIN     FDDTSTL1                           65
     C*
     C**  If no record found, the deal type/sub type is invalid
     C*
     C     *IN65         IFEQ      '1'
     C     RCID11        OREQ      '*'
 
     C                   EVAL      ErrorFound = 'Y'
     C     CDL038        IFNE      'Y'                                                        CDL038
     C                   MOVEL     'MMM1051'     MsgID3
     C                   ELSE                                                                 CDL038
     C                   MOVEL     'MMM1070'     MsgID3                                       CDL038
     C                   ENDIF                                                                CDL038
 
     C                   ENDIF
 
     C                   ENDSR
 
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
      ** Return code (10A, passed back to caller)
     C                   PARM                    RetCodeIn
      ** Message ID 1 - error in Deal Type (7A, returned to caller)
     C                   PARM                    MsgID1
      ** Message ID 2 - error in Deal Subtype (7A, returned to caller)
     C                   PARM                    MsgID2
      ** Message ID 2C - error in Deal Class (7A, returned to caller)                         CDL038
     C                   PARM                    MsgID2C                                      CDL038
      ***Message*ID*3*-*error*in*Deal*Type/Subtype*combination*(7A,*returned                  CDL038
      ** Message ID 3 - error in Deal Type/Subtype/Class combination (7A, returned            CDL038
      ** to caller)
     C                   PARM                    MsgID3
      ** Deal Type OK flag (1A, returned to caller)
     C                   PARM                    DDTypeOK
      ** Deal Type (2A, from caller)
     C                   PARM                    DDType
      ** Deal Subtype (2A, from caller)
     C                   PARM                    DDStyp
      ** Class (4A, from caller)                                                              CDL038
     C                   PARM                    DDClas                                       CDL038
      ** Transaction type (4A, from caller)
     C                   PARM                    TransType
      ** Deal Subtype data structure (Layout of SDDLSTPD, returned to caller)
     C                   PARM                    SDDLST
      ** Action code                                                            CDL006
     C                   PARM                    PActn             1            CDL006
      ** Floating Rate CD Issued                                                              CDL033
     C                   PARM                    CDL033            1                          CDL033
      ** Warning message ID                                                     CDL006
     C                   PARM                    PWMsgID1          7            CDL006
      ** Fiduciary deals                                                                      CDL033
     C                   PARM                    CDL006            1                         BUG9827
                                                                                              CDL038
                                                                                              CDL038
      ** Determine if CDL038 (Extended Deal Sub-Types) is installed                           CDL038
                                                                                              CDL038
     C                   CALL      'AOSARDR0'                                                 CDL038
     C                   PARM      *BLANKS       @RTCD                                        CDL038
     C                   PARM      '*VERIFY'     @OPTN                                        CDL038
     C                   PARM      'CDL038'      @SARD             6                          CDL038
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL038
      *                                                                                       CDL038
     C     @RTCD         IFEQ      *BLANKS                                                    CDL038
     C                   MOVE      'Y'           CDL038            1                          CDL038
     C                   ELSE                                                                 CDL038
     C                   MOVE      'N'           CDL038                                       CDL038
     C                   ENDIF                                                                CDL038
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Key list for deal type/subtype file
     C     @DTSTK        KLIST
     C                   KFLD                    DDTYPE
     C                   KFLD                    DDSTYP
     C                   KFLD                    DDCLAS                                       CDL038
 
      ** Initialise the deal type OK flag
     C                   EVAL      DDTypeOK = 'Y'
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
