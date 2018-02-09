     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate deal type/subtype combination')
      *****************************************************************
      *                                                               *
      *  Midas - IRS Validation Module                                *
      *                                                               *
      *  IRVDEALTSP - Validate deal type/subtype combination          *
      *                                                               *
      *  Function:  This module receives parameters containing        *
      *             putative deal type and subtype, and checks if     *
      *             their interdependence is correct.  If it is OK,   *
      *             the 10A return code will be blank; if it is not,  *
      *             it will contain 'Error'                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CDL038             Date 10May05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 186676 *C *CREATE  Date 27Mar02               *
      *                 Xnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL038 - Extended Deal Sub Type                              *
      *  186676 - Created to validate the deal type/subtype           *
      *           combination for FRA/IRS deals.                      *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Deal subtype received as a parameter
     D DDStyp          S              2A
 
      ** Class received as a parameter                                                        CDL038
     D DDClas          S              4A                                                      CDL038
                                                                                              CDL038
      ** Error message code 1 returned to caller (error in class)                             CDL038
     D Msgid1          S                   LIKE(#MsgID)                                       CDL038
                                                                                              CDL038
      ** Error message code 2 returned to caller (error in combination)                       CDL038
     D Msgid2          S                   LIKE(#MsgID)                                       CDL038
                                                                                              CDL038
      ***Error*message*code*1*returned*to*caller*(error in deal type)                         CDL038
     D*Msgid***********S*******************LIKE(#MsgID)                                       CDL038
 
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
      *                                                                                       CDL038
      * CLASV - CLASS VALIDATION                                                              CDL038
      *                                                                                       CDL038
     C     CDL038        IFEQ      'Y'                                                        CDL038
     C                   EXSR      CLASV                                                      CDL038
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
      * If class is ok                                                                        CDL038
                                                                                              CDL038
     C     MsgId1        IFEQ      *blank                                                     CDL038
 
     C**  Record must exist on FDDTSTL1
     C*
     C     @DTSTK        CHAIN     FDDTSTL1                           65
     C*
     C**  If no record found, the deal type/sub type is invalid
     C*
     C     *IN65         IFEQ      '1'
     C     RCID11        OREQ      '*'
 
     C                   EVAL      ErrorFound = 'Y'
     C     CDL038        IFNE      'Y'                                                        CDL038
     C                   MOVEL     'MMM1051'     MsgID2                                       CDL038
     C                   ELSE                                                                 CDL038
     C                   MOVEL     'MMM1070'     MsgID2                                       CDL038
     C                   ENDIF                                                                CDL038
     C*******************MOVEL     'MMM1051'     MsgID                                        CDL038
      *******************                                                                     CDL038
      ***If*error,*set*the return code                                                        CDL038
     C*******************EVAL      RetCodeIn = 'Error'                                        CDL038
 
     C                   ENDIF
     C                   ENDIF                                                                CDL038
                                                                                              CDL038
      ** If error, set the return code                                                        CDL038
     C                   IF        ErrorFound = 'Y'                                           CDL038
     C                   EVAL      RetCodeIn = 'Error'                                        CDL038
     C                   ENDIF                                                                CDL038
 
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
     C                   MOVEL     'MMM0252'     MsgId1                                       CDL038
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
     C                   MOVEL     'MMM0253'     MsgId1                                       CDL038
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
      ** Message ID 1 - error in Class                   (ret to caller)                      CDL038
     C                   PARM                    MsgID1                                       CDL038
      ** Message ID 2 - error in Deal type-subtype combi (ret to caller)                      CDL038
     C                   PARM                    MsgID2                                       CDL038
      ***Message*ID**-*error in Deal type-subtype combi (ret to caller)                       CDL038
     C*******************PARM                    MsgID                                        CDL038
      ** Deal Type (2A, from caller)
     C                   PARM                    DDType
      ** Deal Subtype (2A, from caller)
     C                   PARM                    DDStyp
      ** Class (4A, from caller)                                                              CDL038
     C                   PARM                    DDClas                                       CDL038
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
 
     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
     C/EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
