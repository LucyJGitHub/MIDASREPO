     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVRF*: OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)              : *
/*OVRF*: OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)             : *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Debit Alt A/c Interest Br & A/c')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVDBAL    - Validate Debit Alternate Account Interest       *
      *               Branch and Account                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD046635           Date 10Aug17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 222462             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD046635 - User permissions are not verified on account      *
      *             input via AMAD API. Change the validation so that *
      *             the user inserting an account is always validated *
      *             to have authority to the branch of the account.   *
      *  222462 - There is no check that the alternate account is     *
      *           live.                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase account code to 10 digits                  *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** RE Account Numbers File
     FACNUM     IF   E           K DISK    INFSR(*PSSR)

      ** RE Interest and Charges File
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)

      ** GL Account by Branch
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCNTLXF)

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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)

     D @NDIGT          C                   CONST('0123456789')

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

     D                 DS
     D**ACKEY1**               1     15                                                       CGL029
     D  ACKEY1                 1     21                                                       CGL029
     D  WWCNUM                 1      6
     D  WWCCY                  7      9
     D**WWACOD**              10     13                                                       CGL029
     D**WWACSQ**              14     15                                                       CGL029
     D  WWACOD                10     19                                                       CGL029
     D  WWACSQ                20     21                                                       CGL029

     D                 DS
     D**ACKEYK**               1     18                                                       CGL029
     D  ACKEYK                 1     24                                                       CGL029
     D**WWCUSK**               1      6  0                                                    CSD027
     D  WWCUSK                 1      6                                                       CSD027
     D  WWCCYK                 7      9
     D**WWACOK**              10     13  0                                                    CGL029
     D**WWACSK**              14     15  0                                                    CGL029
     D**WWBRCK**              16     18                                                       CGL029
     D  WWACOK                10     19  0                                                    CGL029
     D  WWACSK                20     21  0                                                    CGL029
     D  WWBRCK                22     24                                                       CGL029
     D  RETKK                  1     10  0
     D**ACCKYK**              11     15                                                       CGL029
     D  ACCKYK                11     21                                                       CGL029

      ** External data structure for branch codes file
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
                                                                                              CGL029
     D DDCACP          S             21                                                       CGL029
     D DDACOD          S             10                                                       CGL029
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029

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

     C                   MoveL     *Blanks       RetCodeIn
     C                   MoveL     *Blanks       FldNamXAr
     C                   MoveL     *Blanks       MsgIDXAr
     C                   MoveL     *Blanks       MsgDtaXAr
     C                   Z-Add     0             Idx
      *
      ** Validate Debit Branch
      *
      *  If alternate entry Rate condition must exist
     C     DDDACP        IFEQ      *BLANK
     C                   MOVE      *BLANKS       DDDRBR
     C                   ELSE
      *
     C     DDDRBR        IFEQ      *BLANKS
     C                   MOVEL     DBRN          DDDRBR
     C                   ENDIF
      *
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
      *
      **  If alternate entry Can not be the account itself
     C     DDDACP        IFEQ      ACKEY1
     C     DDDRBR        ANDEQ     DDBRCA
     C     DDDACP        OREQ      DDACNO
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71236'     MsgIDXAr(Idx)
      ** If alternate entry and amend mode the account can not be the
      ** alternate of another account.
     C                   ELSE
     C     DDACTN        IFEQ      'A'
     C     WIN44         ANDEQ     '1'
      *
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71225'     MsgIDXAr(Idx)
      *
     C                   ELSE
      *
      ** Format of entry must be Retail A/c Number or Full Account
     C     @NDIGT        CHECK     DDDACP        @POSN1            3 0
     C     @NDIGT        CHECK     DDDACP:10     @POSN2            3 0
     C     ' '           CHECK     DDDACP:11     @POSN3            3 0
     C                   SELECT
     C*****@POSN1        WHENEQ    11                                                         CSD027
     C     @POSN1        WHENLE    11                                                         CSD027
     C     @POSN3        ANDEQ     *ZERO
      *
     C*****@POSN1        WHENEQ    7                                                          CSD027
     C     @POSN1        WHENLE    7                                                          CSD027
     C     @POSN2        ANDEQ     *ZERO
      *
     C                   OTHER
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71225'     MsgIDXAr(Idx)
     C                   ENDSL
      *
      *  If alternate entry account must exist and be live.
      *  alternate of another account.
     C                   MOVEL     *BLANKS       ACKEYK
     C                   MOVEL     DDDACP        ACKEYK
     C                   MOVE      DDDRBR        WWBRCK
      *
     C     ACCKYK        IFEQ      *BLANK
     C                   Z-ADD     RETKK         WURKEY           10 0
     C                   MOVE      *BLANK        DDDRBR
     C                   MOVE      *BLANK        WWBRCK
      *
     C     WURKEY        CHAIN     ACNUM                              80
      *
     C     *IN80         IFEQ      '1'
      *
      ** Alternative account doesn't exist in FILE : ACCNTLXX OR ACNUM
      *
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71224'     MsgIDXAr(Idx)
     C                   ELSE
      *
      **  Alternative account exist in FILE : ACNUM  Setup key
      *
     C                   MOVE      CNUM          WWCUSK
     C                   MOVE      CCY           WWCCYK
     C                   MOVE      ACOD          WWACOK
     C                   MOVE      ACSQ          WWACSK
     C                   MOVE      BRCA          WWBRCK
     C                   MOVE      BRCA          DDDRBR                                     MD046635
     C                   END
     C                   END
     C                   END
     C                   END
     C     Idx           IFEQ      0
     C*****WWACK3****    SETLL     ACCNTLXX                               80                  222462
     C**** *IN80 ****    IFEQ      '0'                                                        222462
      *                                                                                       222462
     C     WWACK3        CHAIN     ACCNTLXX                           80                      222462
     C     *IN80         IFEQ      '1'                                                        222462
     C     *IN80         OREQ      '0'                                                        222462
     C     ACST          ANDNE     ' '                                                        222462
      *
      **  ALTERNATIVE ACCOUNT DOESN'T EXIST IN FILE : ACCNTLXXOR ACNUM
      *
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71224'     MsgIDXAr(Idx)
      *
     C                   ELSE
      *
      **  Alternative account can not have any alternate.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      WWBRCK        @BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANKS
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71852'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** IF NOT FOUND NOT RETAIL OK
     C     WWACK2        CHAIN     REIACDF                            80
     C     *IN80         IFEQ      '0'
     C     DACP          IFNE      *BLANKS
     C     CACP          ORNE      *BLANKS
     C     CHAC          ORNE      *BLANKS
     C                   Move      'N'           DDDACPOk
     C                   Move      'N'           DDDRBROk
     C                   Add       1             Idx
     C                   MoveL     'DDDACP'      FldNamXAr(Idx)
     C                   MoveL     'RE71224'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   END
     C                   END
     C                   END
      *
      **  Rate/Spread (SDSIG) must not be '-' if a Base Rate Type (DDDRIB)
      **  is entered along with an Alternate account (DDDACP)
     C     DDDRIB        IFEQ      *BLANKS
     C     DDDSIG        ANDEQ     '-'
     C     DDDACP        ANDNE     *Blanks
     C                   Move      'N'           DDDSIGOk
     C                   Add       1             Idx
     C                   MoveL     'DDDSIG'      FldNamXAr(Idx)
     C                   MoveL     'RE71238'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDRBROk      IfEq      'N'
     C     DDDACPOk      OrEq      'N'
     C     DDDSIGOk      OrEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *Entry        Plist
      *
      ** INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDDRBR            3
     C**********         Parm                    DDDACP           15                          CGL029
     C                   Parm                    DDDACP           21                          CGL029
     C                   Parm                    DDDRIB            2
     C                   Parm                    DDDSIG            1
     C                   Parm                    DDACNO           10
     C                   Parm                    DDBRCA            3
     C                   Parm                    DDACTN            1
     C                   Parm                    DDCUSN            6
     C                   Parm                    DDCCY             3
     C**********         Parm                    DDACOD            4                          CGL029
     C                   Parm                    DDACOD                                       CGL029
     C                   Parm                    DDACSQ            2
      *
     C                   Parm                    WIN44             1
      *
      ** ICD
     C                   Parm                    DBRN              3
      *
      ** OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Alternate Account Branch - Ok
      ** Alternate Account - Ok
      ** Rate Spread Sign - Ok
     C                   Parm                    DDDRBROk          1
     C                   Parm                    DDDACPOk          1
     C                   Parm                    DDDSIGOk          1
      *
      ** KEY LIST TO ACCESS ALTERNATIVE ACCOUNTS ON REAIC
     C     WWACK2        KLIST
     C                   KFLD                    WWCUSK
     C                   KFLD                    WWCCYK
     C                   KFLD                    WWACOK
     C                   KFLD                    WWACSK
     C                   KFLD                    WWBRCK
      *
      ** KEY LIST TO ACCESS ALTERNATIVE ACCOUNTS ON ACCBR
     C     WWACK3        KLIST
     C                   KFLD                    WWBRCK
     C                   KFLD                    WWCUSK
     C                   KFLD                    WWCCYK
     C                   KFLD                    WWACOK
     C                   KFLD                    WWACSK
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area

     C/COPY ZACPYSRC,DBFIELDS

     C                   ENDSR                                                  *** InzEnd ***
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
