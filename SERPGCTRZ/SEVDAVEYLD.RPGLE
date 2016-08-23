     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Portfolio Yield Rate')
      *****************************************************************
      *                                                               *
      *  Midas - Security Trading Module.                             *
      *                                                               *
      *  SEVDAVEYLD - Validate Average Yield Rate.                    *
      *                                                               *
      *  Function:  This module performs the validation for the       *
      *             Average Yield Rate.                               *
      *                                                               *
      *  This module is an ILE/RPG IV conversion of the validation    *
      *  routine for the said field. This routine has been retrieved  *
      *  from SE0070 and has been converted to ILE RPG and copied into*
      *  this member.  Necessary code to make this compileable has    *
      *  been added (entry and exit points and some declares).        *
      *                                                               *
      *  The existing code has not been changed except:               *
      *  - to remove dead lines                                       *
      *  - to convert a couple of EXSRs to CALLBs                     *
      *                                                               *
      *  Component of: SE0070 - Depot Movement Maintenance            *
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
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CPL002             Date 08MAR99               *
      *                 CAP003 *CREATE     Date 15Feb98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FINVTP     IF   E           K DISK
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input fields
      ** ------------
 
      ** Screen Fields
 
     D DDCYLD          S             12A
     D DDPTFR          S              4A
 
      ** Security Details (Use as key fields for PF/INVTPD)
 
     D NMCY            S              3A
     D SITP            S              3A
 
      ** System Input
 
     D PortPreInd      S              1A
 
      ** Output
 
     D CYLD            S             11P 7
     D DDCYLDOk        S              1A
 
      ** Working variable(s)
     D ZALIGNOk        S              1A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
     D ZFIELD          S             16A
     D DPMVtype        S              2A
 
      ** Index for arrays of error message ids etc
 
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Initialization
      *
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
 
     C                   Z-ADD     0             CYLD
      *
      ** Validate
      *
     C                   EXSR      CYLDV
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCYLDOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CYLDV - Validation routine for Average Yield                  *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     CYLDV         BEGSR
 
     C     PortPreInd    IFEQ      'Y'
      *
      ** May only enter YIELD RATE for 'WI' or 'WO'
      *
     C     DPMVType      IFNE      'WI'
     C     DPMVType      ANDNE     'WO'
     C     DDCYLD        ANDNE     *BLANKS
      *
      ** Error 238
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYLD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0361'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCYLDOk
     C                   END
      *
      ** May only enter YIELD RATE if a valid Portfolio has been input
      *
     C     DDPTFR        IFEQ      *BLANKS
     C     DDPTFROk      ANDEQ     'Y'
     C     DDCYLD        ANDNE     *BLANKS
     C     DDCYLDOk      ANDNE     'N'
 
     C     DDPTFROk      OREQ      'N'
     C     DDCYLD        ANDNE     *BLANKS
      *
      ** Error 239
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYLD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0226'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCYLDOk
     C                   END
      *
      ** Obtain security Processing type
      ** Yield may not be entered for Processing types 2, 4 AND 7
      *
     C     DDCYLD        IFNE      *BLANKS
 
     C     INVKA         KLIST
     C                   KFLD                    NMCY
     C                   KFLD                    SITP
 
     C     INVKA         CHAIN     INVTPDF                            33
      *
     C     *IN33         IFEQ      '1'
     C                   MOVEL     'INVTPD  '    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     *BLANKS       DBKEY                          ****************
     C                   MOVEL     NMCY          DBKEY                          * DB ERROR 901 *
     C                   MOVE      SITP          DBKEY                          ****************
     C                   EXSR      *PSSR
     C                   END
 
     C     PROT          IFEQ      '2'
     C     PROT          OREQ      '4'
     C     PROT          OREQ      '7'
      *
      ** Error 240
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYLD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0227'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCYLDOk
     C                   END
 
     C                   END
      *
      ** Check that a valid amount has been input via SR/ZALIGN
      *
     C     DDCYLDOk      IFNE      'N'
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCYLD        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     4             ZADIG
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
 
     C     ZALIGNok      IFEQ      'N'
      *
      ** Error 241
      *
     C                   ADD       1             Idx
     C                   MOVEL     'DDCYLD'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0228'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCYLDOk
     C                   ELSE
     C                   MOVE      ZFIELD        CYLD
     C                   END
 
     C                   END
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
 
      ** Return Code error Indicator
     C                   PARM                    RetCodeIn
 
      ** Received Parameters
      ** -------------------
 
      ** Screen details
      ** Customer Yield (12A)
      ** Portfolio Reference (4A)
     C                   PARM                    DDCYLD
     C                   PARM                    DDPTFR
 
      ** Security Details (Use as key fields for PF/INVTPD)
      ** Nominal Currency (3A)
      ** Investment type (3A)
     C                   PARM                    NMCY
     C                   PARM                    SITP
 
      ** Depot movement details
      ** Depot movement Type
      ** Portfolio Reference Ok indicator
 
     C                   PARM                    DPMVType
     C                   PARM                    DDPTFROk          1
 
      ** System Input
 
      ** Portfolio Management Module Indicator (1A)
     C                   PARM                    PortPreInd
 
      ** Returned parameters
      ** -------------------
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
 
      ** Customer Yield Ok Indicator  (1A)
      ** Customer Yield  (11P 7)
     C                   PARM                    DDCYLDOk
     C                   PARM                    CYLD
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
