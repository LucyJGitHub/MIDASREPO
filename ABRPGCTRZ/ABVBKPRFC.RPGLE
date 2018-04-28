     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate books and profit centres')
      *****************************************************************
      *                                                               *
      *  Midas - Internal Contracts (Dealing) Module                  *
      *                                                               *
      *  FXVBKPRFC - Validate Books and Profit Centres                *
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
      * Midas Release 4.01.02 ----------------------------------------*
      *  Prev Amend No. 206308             Date 17JUN02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004 *CREATE     Date 08Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  206308 - Default the correct profit centre for the           *
      *           corresponding book code according to the matrix     *
      *           profit centre table.                                *
      *  CAP004 - API's Phase 3.                                      *
      *                                                               *
      *****************************************************************
 
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
 
      ** External data structure for book codes file
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** External data structure for profit centre details file
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
 
      ** External data structure for access programs (short)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Customer number
     D JUDCNO          S              6S 0
 
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
 
     C                   MOVE      *BLANK        JUFXBC
     C                   MOVE      *BLANK        JUMMBC
     C                   MOVE      *BLANK        JUPRFC
     C                   MOVE      *BLANK        JUMMPC
 
      *
      * FXBCV - FX BOOK CODE VALIDATION
      *
     C                   EXSR      FXBCV
      *
      * MMBCV - MM BOOK CODE VALIDATION
      *
     C                   EXSR      MMBCV
      *
      * PRFC - PROFIT CENTRE VALIDATION
      * If profit centres used
      * and no errors on varoius fields
      *
     C     BKPRCU        IFEQ      'Y'
     C     DDDLTPOK      ANDNE     'N'
     C     DDDSTPOK      ANDNE     'N'
     C     DDBRCDOK      ANDNE     'N'
     C     DDFXBCOK      ANDNE     'N'
     C     DDMMBCOK      ANDNE     'N'
      *
      * If PCA installed validate FX & MM profit centres
      * else validate single profit centre
      *
     C     BGN0ST        IFEQ      'Y'
     C                   EXSR      PRFCV_PCA
     C                   ELSE
     C                   EXSR      PRFCV
     C                   END
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDFXBCOK      IFEQ      'N'
     C     DDMMBCOK      OREQ      'N'
     C     DDPRFCOK      OREQ      'N'
     C     DDMMPCOK      OREQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * FXBCV - FX BOOK CODE VALIDATION
      *****************************************************************
     C     FXBCV         BEGSR
      *
      * If it is defined
      * Check that the book code exists
      *
     C     DDFXBC        IFNE      *BLANKS
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDFXBC        @AJCD             3
     C     SDBOOK        PARM      SDBOOK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDFXBCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFXBC'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0179'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     BDBKCD        DDFXBC
     C                   END
     C                   END
      *
      * Update FX book code on deal
      *
     C                   MOVE      DDFXBC        JUFXBC
     C*
     C                   ENDSR
      *******************************************************************
      /EJECT
      *****************************************************************
      * MMBCV - MM BOOK CODE VALIDATION
      *****************************************************************
     C     MMBCV         BEGSR
      *
      * If it is defined
      * Check that the book code exists
      *
     C     DDMMBC        IFNE      *BLANKS
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDMMBC        @AJCD             3
     C     SDBOOK        PARM      SDBOOK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDMMBCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMMBC'      FldNamXAr(Idx)
     C                   MOVEL     'ABM0180'     MsgIdXAr(Idx)
     C                   ELSE
     C                   MOVEL     BDBKCD        DDMMBC
     C                   END
     C                   END
      *
      * Update FX book code on deal
      *
     C                   MOVE      DDMMBC        JUMMBC
     C*
     C                   ENDSR
      *******************************************************************
      /EJECT
      *****************************************************************
      * PRFCV_PCA - PROFIT CENTRE VALIDATION IF PCA INSTALLED
      *****************************************************************
     C     PRFCV_PCA     BEGSR
      *
      ** Validate the MM Profit Centre
      *
     C     DDMMPC        IFNE      *BLANKS
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDMMPC        @DSKEY            4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** Invalid profit centre
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDMMPCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMMPC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   GOTO      EPRFCV_PCA
     C                   ENDIF
     C                   MOVE      DSPCCD        DDMMPC
     C                   MOVE      DSPCCD        JUMMPC
     C                   ENDIF
      *
      ** If field left blank only set to default if Profit-centre-
      ** default-used flag (BKPCDU) is YES. Else leave blank.
      *
     C     DDMMPC        IFEQ      *BLANKS
     C     BKPCDU        ANDEQ     'Y'
      *
      ** Get Default from matrix
      *
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       @RTNCD            1
     C***********        PARM      DDFXBC        @BOKCI            2                          206308
     C                   PARM      DDMMBC        @BOKCI            2                          206308
     C                   PARM      DDDLTP        @DLTPI            5
     C                   PARM      DDDSTP        @DLSTI            2
     C                   PARM      DDBRCD        @BRCDI            3
     C                   PARM      DEPT          @DEPTI            3
     C                   PARM      PSUser        @USERI           10
     C                   PARM      BkgBrACOC     @ACOFI            2
     C                   PARM      BkgBrCUST     @CUSTI            6
     C                   PARM                    @PRFCO            4
      * If no profit centre defaulted                                                         206308
      *                                                                                       206308
     C     @RTNCD        IFNE      '0'                                                        206308
     C                   MOVE      'N'           DDMMPCOK                                     206308
     C                   ADD       1             Idx                                          206308
     C                   MOVEL     'DDMMPC'      FldNamXAr(Idx)                               206308
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)                                206308
     C                   GOTO      EPRFCV_PCA                                                 206308
     C                   ENDIF                                                                206308
     C                   MOVE      @PRFCO        DDMMPC                                       206308
     C                   MOVE      @PRFCO        JUMMPC                                       206308
     C                   ENDIF                                                                206308
     C*                                                                                       206308
     C*****@RTNCD        IFNE      '0'                                                        206308
     C***********        CALL      'AOPRFMR0'                                                 206308
     C***********        PARM      *BLANKS       @RTNCD                                       206308
     C***********        PARM      DDMMBC        @BOKCI                                       206308
     C***********        PARM      DDDLTP        @DLTPI                                       206308
     C***********        PARM      DDDSTP        @DLSTI                                       206308
     C***********        PARM      DDBRCD        @BRCDI                                       206308
     C***********        PARM      DEPT          @DEPTI                                       206308
     C***********        PARM      PSUser        @USERI                                       206308
     C***********        PARM      BkgBrACOC     @ACOFI                                       206308
     C***********        PARM      BkgBrCUST     @CUSTI                                       206308
     C***********        PARM                    @PRFCO                                       206308
     C***********        ENDIF                                                                206308
      **                                                                                      206308
      **If*no*profit*centre*defaulted                                                         206308
      **                                                                                      206308
     C*****@RTNCD        IFNE      '0'                                                        206308
     C***********        MOVE      'N'           DDMMPCOK                                     206308
     C***********        ADD       1             Idx                                          206308
     C***********        MOVEL     'DDMMPC'      FldNamXAr(Idx)                               206308
     C***********        MOVEL     'FXM4001'     MsgIdXAr(Idx)                                206308
     C***********        GOTO      EPRFCV_PCA                                                 206308
     C***********        ENDIF                                                                206308
     C***********        MOVE      @PRFCO        DDMMPC                                       206308
     C***********        MOVE      @PRFCO        JUMMPC                                       206308
     C***********        ENDIF                                                                206308
      *
      ** Validate the FX Profit Centre
      *
     C     DDPRFC        IFNE      *BLANKS
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDPRFC        @DSKEY
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** Invalid profit centre
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDPRFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   GOTO      EPRFCV_PCA
     C                   ENDIF
     C                   MOVE      DSPCCD        DDPRFC
     C                   MOVE      DSPCCD        JUPRFC
     C                   ENDIF
      *                                                                                       206308
      ** If field left blank only set to default if Profit-centre-                            206308
      ** default-used flag (BKPCDU) is YES. Else leave blank.                                 206308
      *                                                                                       206308
     C     DDPRFC        IFEQ      *BLANKS                                                    206308
     C     BKPCDU        ANDEQ     'Y'                                                        206308
      *                                                                                       206308
      ** Get Default from matrix                                                              206308
      *                                                                                       206308
     C                   CALL      'AOPRFMR0'                                                 206308
     C                   PARM      *BLANKS       @RTNCD            1                          206308
     C                   PARM      DDFXBC        @BOKCI            2                          206308
     C                   PARM      DDDLTP        @DLTPI            5                          206308
     C                   PARM      DDDSTP        @DLSTI            2                          206308
     C                   PARM      DDBRCD        @BRCDI            3                          206308
     C                   PARM      DEPT          @DEPTI            3                          206308
     C                   PARM      PSUser        @USERI           10                          206308
     C                   PARM      BkgBrACOC     @ACOFI            2                          206308
     C                   PARM      BkgBrCUST     @CUSTI            6                          206308
     C                   PARM                    @PRFCO            4                          206308
      *                                                                                       206308
      * If no profit centre defaulted                                                         206308
      *                                                                                       206308
     C     @RTNCD        IFNE      '0'                                                        206308
     C                   MOVE      'N'           DDPRFCOK                                     206308
     C                   ADD       1             Idx                                          206308
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)                               206308
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)                                206308
     C                   GOTO      EPRFCV_PCA                                                 206308
     C                   ENDIF                                                                206308
     C                   MOVE      @PRFCO        DDPRFC                                       206308
     C                   MOVE      @PRFCO        JUPRFC                                       206308
     C                   ENDIF                                                                206308
     C*                                                                                       206308
      *
      ** If field left blank only set to default if Profit-centre-
      ** default-used flag (BKPCDU) is YES
      *
     C     DDPRFC        IFEQ      *BLANKS
     C     BKPCDU        ANDEQ     'Y'
     C     DDMMPC        ANDNE     *BLANKS
      *
      * Reaccess MM profit centre for funding profit centre
      *
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDMMPC        @DSKEY
     C     SDPRFC        PARM      SDPRFC        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDMMPCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMMPC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   GOTO      EPRFCV_PCA
     C                   ENDIF
      *
      * Default FX profit centre
      *
     C     DSFPPC        IFNE      *BLANKS
     C                   MOVE      DSFPPC        DDPRFC
     C                   MOVE      DSFPPC        JUPRFC
     C                   ELSE
     C                   MOVE      DDMMPC        DDPRFC
     C                   MOVE      DDMMPC        JUPRFC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EPRFCV_PCA    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PRFCV - PROFIT CENTRE VALIDATION IF PCA NOT INSTALLED
      *****************************************************************
     C     PRFCV         BEGSR
      *
      ** Validate the Profit Centre
      *
     C     DDPRFC        IFNE      *BLANKS
     C                   CALL      'AOPRFCR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDPRFC        @DSKEY            4
     C     SDPRFC        PARM      SDPRFC        DSFDY
      *
      ** Invalid profit centre
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDPRFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   GOTO      EPRFCV
     C                   END
     C                   MOVE      DSPCCD        DDPRFC
     C                   MOVE      DSPCCD        JUPRFC
     C                   END
      *
      **  If field left blank only set to default if Profit-centre-
      **  default-used flag (BKPCDU) is YES. Else leave blank.
      *
     C     DDPRFC        IFEQ      *BLANKS
     C     BKPCDU        ANDEQ     'Y'
      *
      ** Get Default from matrix
      *
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       @RTNCD            1
     C                   PARM      DDFXBC        @BOKCI            2
     C                   PARM      DDDLTP        @DLTPI            5
     C                   PARM      DDDSTP        @DLSTI            2
     C                   PARM      DDBRCD        @BRCDI            3
     C                   PARM      DEPT          @DEPTI            3
     C                   PARM      PSUser        @USERI           10
     C                   PARM      BkgBrACOC     @ACOFI            2
     C                   PARM      BkgBrCUST     @CUSTI            6
     C                   PARM                    @PRFCO            4
     C     @RTNCD        IFNE      '0'
     C                   CALL      'AOPRFMR0'
     C                   PARM      *BLANKS       @RTNCD            1
     C                   PARM      DDMMBC        @BOKCI            2
     C                   PARM      DDDLTP        @DLTPI            5
     C                   PARM      DDDSTP        @DLSTI            2
     C                   PARM      DDBRCD        @BRCDI            3
     C                   PARM      DEPT          @DEPTI            3
     C                   PARM      PSUser        @USERI           10
     C                   PARM      BkgBrACOC     @ACOFI            2
     C                   PARM      BkgBrCUST     @CUSTI            6
     C                   PARM                    @PRFCO            4
     C                   END
      *
      * If no profit centre defaulted
      *
     C     @RTNCD        IFNE      '0'
     C     @RTNCD        ANDNE     *BLANKS
     C                   MOVE      'N'           DDPRFCOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPRFC'      FldNamXAr(Idx)
     C                   MOVEL     'FXM4001'     MsgIdXAr(Idx)
     C                   GOTO      EPRFCV
     C                   END
     C                   MOVE      @PRFCO        DDPRFC
     C                   MOVE      @PRFCO        JUPRFC
     C                   END
      *
     C     EPRFCV        ENDSR
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
      ** Deal Type
      ** Deal Subtype
      ** Deal Type
      ** Branch
      ** FX Book Code
      ** MM Book Code
      ** FX Profit Centre
      ** MM Profit Centre
     C                   PARM                    DDDLTP            2            deal type
     C                   PARM                    DDDSTP            2            deal sub type
     C                   PARM                    DDBRCD            3            booking branch
     C                   PARM                    DDFXBC            2            book
     C                   PARM                    DDMMBC            2            book
     C                   PARM                    DDPRFC            4            profit centre
     C                   PARM                    DDMMPC            4            profit centre
      *
      ** Deal Type OK
      ** Deal Subtype OK
      ** Booking branch OK
     C                   PARM                    DDDLTPOK          1
     C                   PARM                    DDDSTPOK          1
     C                   PARM                    DDBRCDOK          1
      *
      ** Booking branch customer
      ** Booking branch account officer.
     C                   PARM                    BkgBrCUST         6
     C                   PARM                    BkgBrACOC         2
      *
      * ICD
     C                   PARM                    BKPRCU            1
     C                   PARM                    BKPCDU            1
     C                   PARM                    BGN0ST            1
      * Dept from ZMUSER
     C                   PARM                    DEPT              3
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** FX Book - OK
      ** MM Book - OK
      ** FX Profit Centre - OK
      ** MM Profit Centre - OK
     C                   PARM                    DDFXBCOK          1
     C                   PARM                    DDMMBCOK          1
     C                   PARM                    DDPRFCOK          1
     C                   PARM                    DDMMPCOK          1
      *
      ** Deal FX Book
      ** Deal MM Book
      ** Deal FX Profit Centre
      ** Deal MM Profit Centre
      *
     C                   PARM                    JUFXBC            2
     C                   PARM                    JUMMBC            2
     C                   PARM                    JUPRFC            4
     C                   PARM                    JUMMPC            4
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
(c) Misys International Banking Systems Ltd. 2001
