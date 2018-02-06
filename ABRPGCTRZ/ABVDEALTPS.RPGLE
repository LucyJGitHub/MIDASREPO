     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate deal type & deal sub-type')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  ABVDEALTPS - Validate Deal Type and Sub Type                 *
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
      *                 CDL038             Date 10May05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)                                       CDL038
                                                                                              CDL038
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
 
      ** Clear output deal fields
 
   25C                   MOVEL     *BLANK        JUMDTY
     C                   MOVEL     *BLANK        JUSTYP
     C                   MOVEL     *BLANK        JUCLAS                                       CDL038
 
      *
      * DLTPV - DEAL TYPE VALIDATION
      *
     C                   EXSR      DLTPV
      *
      * DSTPV - DEAL SUB TYPE VALIDATION
      *
     C                   EXSR      DSTPV
      *                                                                         CDL038
      * CLASV - CLASS VALIDATION                                                CDL038
      *                                                                         CDL038
     C     CDL038        IFEQ      'Y'                                          CDL038
     C                   EXSR      CLASV                                        CDL038
     C                   ENDIF                                                  CDL038
      *                                                                         CDL038
      * DTDSV - DEAL TYPE/ DEAL SUB TYPE/ CLASS COMBINED VALIDATION             CDL038
      *                                                                         CDL038
     C     DDDltpOK      IFEQ      'Y'                                          CDL038
     C     DDDstpOK      ANDEQ     'Y'                                          CDL038
     C     DDClasOK      ANDEQ     'Y'                                          CDL038
     C                   EXSR      DTDSV                                        CDL038
     C                   END                                                    CDL038
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDDLTPOK      IFEQ      'N'
     C     DDDSTPOK      OREQ      'N'
     C     DDClasOK      OREQ      'N'                                                        CDL038
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
      * If Deal Type is blank, default it to 'PS' (Pposition Swap)
      *
     C     DDDLTP        IFEQ      *BLANKS
     C                   MOVE      'PS'          DDDLTP
     C                   END
      *
      * Deal Type must be 'PS'
      *
     C     DDDLTP        IFNE      'PS'
     C                   MOVE      'N'           DDDLTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDLTP'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0203'     MsgIdXAr(Idx)
     C                   END
      *
      * Update Midas deal type on deal
      *
   25C                   MOVEL     DDDLTP        JUMDTY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DSTPV - DEAL SUB TYPE VALIDATION
      *****************************************************************
     C     DSTPV         BEGSR
      *
      * If Deal Subtype is blank, default it to 'PS'
      *
     C     DDDSTP        IFEQ      *BLANKS
     C                   MOVE      'PS'          DDDSTP
     C                   END
      *
      ** Check that the deal subtype exists
      *
     C                   CALLB     'AODLSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDDSTP        @AQCD             2
     C     SDDLST        PARM      SDDLST        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDDSTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDSTP'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0118'     MsgIdXAr(Idx)
   25C                   ELSE
   25C                   MOVEL     ASDSTC        DDDSTP
     C                   END
      *
      * Update deal sub type on deal
      *
     C                   MOVEL     DDDSTP        JUSTYP
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
      * Update deal class on deal                                                             CDL038
      *                                                                                       CDL038
     C                   MOVEL     DDCLAS        JUCLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * DTDSV - DEAL TYPE/ DEAL SUB TYPE/CLASS COMBINED VALIDATION                            CDL038
      *****************************************************************                       CDL038
     C     DTDSV         BEGSR                                                                CDL038
      *                                                                                       CDL038
      * The deal type/sub-type combination must exist                                         CDL038
      *                                                                                       CDL038
     C     FDDTSK        KLIST                                                                CDL038
     C                   KFLD                    DDDLTP                                       CDL038
     C                   KFLD                    DDDSTP                                       CDL038
     C                   KFLD                    DDCLAS                                       CDL038
     C     FDDTSK        CHAIN     FDDTSTL1                           99                      CDL038
      *                                                                                       CDL038
      * If no record found,                                                                   CDL038
      *                                                                                       CDL038
     C     *IN99         IFEQ      '1'                                                        CDL038
     C     RCID11        OREQ      '*'                                                        CDL038
     C                   MOVE      'N'           DDDltpOK                                     CDL038
     C                   MOVE      'N'           DDDstpOK                                     CDL038
     C                   MOVE      'N'           DDClasOK                                     CDL038
     C                   ADD       1             Idx                                          CDL038
     C                   MOVEL     'DDDLTP'      FldNamXAr(Idx)                               CDL038
     C     CDL038        IFNE      'Y'                                                        CDL038
     C                   MOVEL     'MMM1051'     MsgIdXAr(Idx)                                CDL038
     C                   ELSE                                                                 CDL038
     C                   MOVEL     'MMM1070'     MsgIdXAr(Idx)                                CDL038
     C                   ENDIF                                                                CDL038
     C                   END                                                                  CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
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
      ** Deal Type & Deal Sub-Type
      ** and Class                                                                            CDL038
     C                   PARM                    DDDLTP            2
     C                   PARM                    DDDSTP            2
     C                   PARM                    DDCLAS            4                          CDL038
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
     C                   PARM                    DDDLTPOK          1
     C                   PARM                    DDDSTPOK          1
     C                   PARM                    DDClasOK          1                          CDL038
      *
      ** Deal Type & Deal Sub-Type
      ** and Class                                                                            CDL038
     C                   PARM                    JUMDTY            2
     C                   PARM                    JUSTYP            2
     C                   PARM                    JUCLAS            4                          CDL038
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
