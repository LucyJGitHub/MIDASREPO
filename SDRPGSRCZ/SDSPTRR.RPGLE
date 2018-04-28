     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot Rate retrieve a record')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDSPTRR - Spot Rate retrieve a record                        *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG22321           Date 20Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BUG8205            Date 22Aug05               *
      *                 BUG8130            Date 10Aug05               *
      *                 BUG4469            Date 06Oct04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 26Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22321 - Mapping error causes Midas Error in Spot Rates    *
      *             input. (Recompile)                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG8205 - Recompiled due to changes in file SDVSPTRPD        *
      *            Applied fix 209061                                 *
      *  BUG8130- Recompiled as there have been changes to SDVSPTRPD  *
      *  BUG4469- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time by    *
      *           passing the Timestamp out to API.                   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
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
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D SPTRScnFmt    E DS                  EXTNAME(SDSPTRPD)
      * Spot Rate in screen format
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D SPTRFilFmt    E DS                  EXTNAME(SDVSPTRPD)
     D  QQCSCD1      E                     EXTFLD(QQCSCD)                                     CGL029
      * Spot Rate in file format
 
      * (Current) Transaction record in file Format
     D TranFilFmt    E DS                  EXTNAME(SDCURRPD)
     D  QQSPAE1      E                     EXTFLD(QQSPAE)                                     CGL029
     D  QQFTAE1      E                     EXTFLD(QQFTAE)                                     CGL029
     D  QQSWAE1      E                     EXTFLD(QQSWAE)                                     CGL029
     D  QQTAC41      E                     EXTFLD(QQTAC4)                                     CGL029
     D  QQTAC51      E                     EXTFLD(QQTAC5)                                     CGL029
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Define module parameter fields for call to CVT module
     D DDCYNM          S                   LIKE(A6CYNM)
     D DDDCY2          S                   LIKE(A6DLCI)
     D DDDLCY          S                   LIKE(A6DLCI)
     D DDMDI2          S                   LIKE(A6MDIN)
     D DDSPR2          S                   LIKE(DDSPRT)
     D DDSWCY          S                   LIKE(A6SWCY)
     D DDSWC2          S                   LIKE(A6SWCY)
     D DDVSEU          S                   LIKE(A6CYCD)
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDCYCD_IN         3
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set action code to enquire, unless authorising
     C                   CLEAR                   SPTRFilFmt
 
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SDSPTRRED
     C                   ELSE
     C                   MOVEL     DDCYCD_IN     @CYCD             3
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If Spot Rate read and no error message returned
     C                   IF        RetCodeIn  = *BLANK and
     C                             @CYCD <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @CYCD         DDCYCD
     C                   EXSR      SDSPTRRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SDSPTRCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      AVTMESTMP     @TimeStamp       26                         BUG4469
     C                   EVAL                    Buffer = SPTRScnFmt
     C                                                   + @TimeStamp                        BUG4469
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     SDSPTRRED     BEGSR
      *
     C                   RESET                   RetCodeIn
      *
     C                   CALLB     'SDSPTRRED'
 
     C                   PARM      *BLANK        RetCodeIn
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTRNN            3
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
     C                   PARM                    @ERRMS            7
     C                   PARM                    @SCRED            3
 
     C                   ENDSR
      **********************************************************************
     C     SDSPTRRTV     BEGSR
 
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'SDSPTRRTV'
 
      * Return code
     C                   PARM      *BLANK        ReturnCode
      * INPUTS
      *
      * Mode of operation (front office or not front office)
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * (Midas) Transaction Number
     C                   PARM                    DDCYCD            3
      *
      * OUTPUTS
      *
      * (Current) Transaction in file format
     C                   PARM                    SPTRFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Transaction Number
     C                   PARM                    DDCYCDOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      **********************************************************************
     C     SDSPTRCVT     BEGSR
 
     C                   RESET                   RetCodeIn
      *
     C                   CALLB     'SDSPTRCVT'
 
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Spot Rates Transaction - file formats
     C                   PARM                    SPTRFilFmt
      *
      * Output parameters
      *
      * Spot Rates Transaction Details - screen formats
     C                   PARM                    SPTRScnFmt
 
      * Currency Name
     C                   PARM                    DDCYNM
 
      * Dealing currency
     C                   PARM                    DDDLCY
 
      * SWIFT currency code
     C                   PARM                    DDSWCY
 
      * BKEURO currency
     C                   PARM                    DDVSEU
 
      * Spot Rate against base currency (when DDSPRT is against BKEURO)
      * (output screen field)
     C                   PARM                    DDSPR2
 
      * Multiply divide indicator tied to DDSPR2
      * (output screen field)
     C                   PARM                    DDMDI2
 
      * Dealing currency tied to DDSPR2 (output screen field)
     C                   PARM                    DDDCY2
 
      * Swift currency code tied to DDSPR2 (output screen field)
     C                   PARM                    DDSWC2
 
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
