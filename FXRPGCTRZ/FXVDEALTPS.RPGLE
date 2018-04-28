     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Val deal type/sub-type & fed funds ind')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FXVDEALTPS - Validate Deal Type/Sub Type & Fed Funds Ind     *
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
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. CDL038             Date 10May05               *
      *                 209009             Date 03Sep02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 148748             Date 25Nov98               *
      *                 CAP002  *CREATE    Date 08Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type                              *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  148748 - Correct condition of cross check validation         *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
 
      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009
 
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
 
 
      ** External data structure for deal types/sub types file
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for transaction classes file                                 CDL038
     D SDTCLS        E DS                  EXTNAME(SDTCLSPD)                                  CDL038
                                                                                              CDL038
      ** External data structure for SAR details                                              CDL038
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CDL038
                                                                                              CDL038
      ** External data structure for access programs (short)
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
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
      *
      * DLTPV - DEAL TYPE VALIDATION
      *
     C                   EXSR      DLTPV
      *
      * DLSTV - DEAL SUB TYPE VALIDATION
      *
     C                   EXSR      DLSTV
      *                                                                         CDL038
      * CLASV - CLASS VALIDATION                                                CDL038
      *                                                                         CDL038
     C     CDL038        IFEQ      'Y'                                          CDL038
     C                   EXSR      CLASV                                        CDL038
     C                   ENDIF                                                  CDL038
      *
      **DTDSV*-*DEAL*TYPE/*DEAL*SUB*TYPE*COMBINED*VALIDATION                    CDL038
      * DTDSV - DEAL TYPE/ DEAL SUB TYPE/ CLASS COMBINED VALIDATION             CDL038
      *
     C*****DDDLTP        IFEQ      'Y'                                          148748
     C*****DDDLST        ANDEQ     'Y'                                          148748
     C     DDDltpOK      IFEQ      'Y'                                          148748
     C     DDDlstOK      ANDEQ     'Y'                                          147748
     C     DDClasOK      ANDEQ     'Y'                                          CDL038
     C*****DDDLST        ANDNE     *BLANKS                                      CDL038
     C                   EXSR      DTDSV
     C                   END
      *
      * FEDFV - FEDERAL FUNDS INDICATOR VALIDATION
      *
     C                   EXSR      FEDFV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDltpOK      IFEQ      'N'
     C     DDDlstOK      OREQ      'N'
     C     DDClasOK      OREQ      'N'                                                        CDL038
     C     DDFedfOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * DLTPV - DEAL TYPE VALIDATION
      *****************************************************************
     C     DLTPV         BEGSR
      *
      * Deal Type can't be blank
      *
     C     DDDLTP        IFEQ      *BLANKS
     C                   MOVE      'N'           DDDltpOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLTP'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0245'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * If Deal Type is not blank it must take one of the following values
      *
     C     DDDLTP        IFNE      'FP'
     C     DDDLTP        ANDNE     'FS'
     C     DDDLTP        ANDNE     'CX'
     C     DDDLTP        ANDNE     'PI'
     C     DDDLTP        ANDNE     'SI'
     C     DDDLTP        ANDNE     'OP'
     C     DDDLTP        ANDNE     'OT'
     C     DDDLTP        ANDNE     'SW'
     C                   MOVE      'N'           DDDltpOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLTP'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0112'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DLSTV - DEAL SUB TYPE VALIDATION
      *****************************************************************
     C     DLSTV         BEGSR
      *
      ** Deal sub type must be defined
      *
     C     DDDLST        IFEQ      *BLANKS
     C                   MOVE      'N'           DDDlstOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0246'     MsgIdXAr(Idx)
     C                   ELSE
      *
      ** Check that the deal subtype exists
      *
     C     DDDLST        IFNE      *BLANKS
     C                   CALLB     'AODLSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDDLST        @AQCD             2
     C     SDDLST        PARM      SDDLST        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDDlstOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLST'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0113'     MsgIdXAr(Idx)
   25C                   ELSE
   25C                   MOVEL     ASDSTC        DDDLST
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * CLASV - CLASS VALIDATION                                                              CDL038
      *****************************************************************                       CDL038
     C     CLASV         BEGSR                                                                CDL038
      *                                                                                       CDL038
      ** Class must be defined                                                                CDL038
      *                                                                                       CDL038
     C     DDCLAS        IFEQ      *BLANKS                                                    CDL038
     C                   MOVE      'N'           DDClasOK                                     CDL038
     C                   ADD       1             Idx                                          CDL038
     C                   MOVEL     'DDCLAS'      FldNamXAr(Idx)                               CDL038
     C                   MOVEL     'FXM0510'     MsgIdXAr(Idx)                                CDL038
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
     C                   MOVE      'N'           DDClasOK                                     CDL038
     C                   ADD       1             Idx                                          CDL038
     C                   MOVEL     'DDCLAS'      FldNamXAr(Idx)                               CDL038
     C                   MOVEL     'FXM0511'     MsgIdXAr(Idx)                                CDL038
   25C                   ELSE                                                                 CDL038
   25C                   MOVEL     TCCLAS        DDCLAS                                       CDL038
     C                   END                                                                  CDL038
     C                   END                                                                  CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      **DTDSV*-*DEAL*TYPE/*DEAL*SUB*TYPE*COMBINED*VALIDATION                                  CDL038
      * DTDSV - DEAL TYPE/ DEAL SUB TYPE/CLASS COMBINED VALIDATION                            CDL038
      *****************************************************************
     C     DTDSV         BEGSR
      *
      * The deal type/sub-type combination must exist
      *
     C     FDDTSK        KLIST
     C                   KFLD                    DDDLTP
     C                   KFLD                    DDDLST
     C                   KFLD                    DDCLAS                                       CDL038
     C     FDDTSK        CHAIN     FDDTSTL1                           99
      *
      * If no record found,
      *
     C     *IN99         IFEQ      '1'
     C     RCID11        OREQ      '*'
     C                   MOVE      'N'           DDDltpOK
     C                   MOVE      'N'           DDDlstOK
     C                   MOVE      'N'           DDClasOK                                     CDL038
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLTP'      FldNamXAr(Idx)
     C     CDL038        IFNE      'Y'                                                        CDL038
     C                   MOVEL     'MMM1051'     MsgIdXAr(Idx)
     C                   ELSE                                                                 CDL038
     C                   MOVEL     'MMM1070'     MsgIdXAr(Idx)                                CDL038
     C                   ENDIF                                                                CDL038
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FEDFV - FEDERAL FUNDS INDICATOR VALIDATION
      *****************************************************************
     C     FEDFV         BEGSR
      *
      * The federal funds ind. must be 'Y' or blank
      *
     C     DDFEDF        IFNE      'Y'
     C     DDFEDF        ANDNE     ' '
     C                   MOVE      'N'           DDFedfOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFEDF'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0387'     MsgIdXAr(Idx)
     C                   ELSE
      *
      * The federal funds ind. can only be 'Y' if US dollars are involved
      *
     C     DDFEDF        IFEQ      'Y'
     C     DDBCCY        ANDNE     BLUSCY
     C     DDSCCY        ANDNE     BLUSCY
     C                   MOVE      'N'           DDFedfOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFEDF'      FldNamXAr(Idx)
     C                   MOVEL     'FXM0393'     MsgIdXAr(Idx)
     C                   END
     C                   END
      *
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
      ** Deal Screen fields
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDLST            2            deal sub type
     C                   PARM                    DDCLAS            4            class         CDL038
     C                   PARM                    DDFEDF            1            fed funds ind
     C                   PARM                    DDBCCY            3            buy ccy
     C                   PARM                    DDSCCY            3            sell ccy
      *
      * ICD
     C                   PARM                    BLUSCY            3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Deal Type - OK
      ** Deal Sub-Type - OK
      ** Class         - OK                                                                   CDL038
      ** Federal Funds - OK
     C                   PARM                    DDDltpOK          1            deal type
     C                   PARM                    DDDlstOK          1            deal sub type
     C                   PARM                    DDClasOK          1            class         CDL038
     C                   PARM                    DDFedfOK          1            fed funds ind
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
(c) Misys International Banking Systems Ltd. 2001
