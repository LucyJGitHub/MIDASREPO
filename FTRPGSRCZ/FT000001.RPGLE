     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Recalculate Payment Charge in Base CCY')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000001 - Recalculate Payment Charge Definitions in Base    *
      *             Currency.                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Function : This program processes charges defined in file    *
      *             FTPCHGPD defined in Other currencies and          *
      *             recalculates the amount due in Base Currency      *
      *                                                               *
      * Last Amend No.  CFT154  *CREATE    Date 26Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT154 - Charges Daily Conversion                            *
      *                                                               *
      *****************************************************************
     FFTPCHGL0  UF   E           K DISK
 
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
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      *
      *****************************************************************
 
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                                                               *
      *       93  Setll                                               *
      *       94  Setll                                               *
      *       96  Chain                                               *
      *       97  Chain                                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
     D  #Diff1         S                   LIKE(SABC01)
     D  #RTCD          S              7
     D  #OPTN          S              7
     D  #CCYA          S                   LIKE(BJCYCD)
     D  #DEC           S              2  0
     D  #INT           S              2  0
     D  #Basccy        S                   LIKE(BJCYCD)
     D  #Basmd         S                   LIKE(A6MDIN)
     D  #Basdec        S              2  0
     D  #Basint        S              2  0
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Midas Switchable features file accessed via access program
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for customer number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      *
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *Loval        SETLL     FTPCHGL0
     C                   READ      FTPCHGL0
     C                   DOW       NOT %EOF(FTPCHGL0)
      *
      * Process only if Other Currency is different than Base Currency
      *
     C                   IF        OTHCCY <> BJCYCD
      *
      *  convert manual Charges
     C                   EXSR      SrChgMA
      *
      *  convert STP Charges
     C                   EXSR      SrChgST
      *
      *  convert Out of Band Charges
     C                   EXSR      SrChgOB
      *
      *  Adjust  manual Charges
     C                   EXSR      SrAdjMA
      *
      *  Adjust  STP  Charges
     C                   EXSR      SrAdjST
      *
      * Update record
     C                   UPDATE    FTPCHGD0
      *
     C                   ENDIF
 
 
     C                   READ      FTPCHGL0
     C                   ENDDO
 
     C                   EVAL      *Inlr = *On
 
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * SrChgMA - Convert Manual Charges                              *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: GETBAS                                                 *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     SrChgMA       BEGSR
      *    *******
      *
      * Update SABC01 & EABC01 with STOC01 & ENOC01 onverted to Base Currency
      * - STOC01 (Start Other Currency Range 1)
      * - ENOC01 (End Other Currency Range 1)
      * - SABC01 (Start Amount Base Currency Range 1)
      * - EABC01 (End Amount Base currency Range 1)
      *
     C                   IF        STOC01 <> 0   AND ENOC01 <> 0
      *
      * - Start Range 1  (SABC01 = STOC01 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC01 = OUTAMT
      *
      * - End Range 1  (EABC01 = ENOC01 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC01 = OUTAMT
     C                   ENDIF
      *
      *
      * Update MIBC01 & MXBC01 with MIOC01 & MAOC01 onverted to Base Currency
      * - MIOC01 (Minimum Charge Other Currency Range 1)
      * - MAOC01 (Maximum Charge Other Currency Range 1)
      * - MIBC01 (Minimum Charge Base Currency Range 1)
      * - MXBC01 (Maximum Charge Base Currency Range 1)
      *
      *
     C                   IF        MIOC01 <> 0   AND MAOC01 <> 0
      *
      * - Minimum Charge 1 (MIBC01 = MIOC01 converted to base currency)
     C                   EVAL      INPAMT = MIOC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC01 = OUTAMT
      *
      * - Maximum Charge 1 (MXBC01 = MAOC01 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC01 = OUTAMT
     C                   ENDIF
 
      * Update SABC02 & EABC02 with STOC02 & ENOC02 onverted to Base Currency
      * - STOC02 (Start Other Currency Range 2)
      * - ENOC02 (End Other Currency Range 2)
      * - SABC02 (Start Amount Base Currency Range 2)
      * - EABC02 (End Amount Base currency Range 2)
      *
     C                   IF        STOC02 <> 0   AND ENOC02 <> 0
      *
      * - Start Range 2  (SABC02 = STOC02 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC02 = OUTAMT
      *
      * - End Range 2  (EABC02 = ENOC02 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC02 = OUTAMT
     C                   ENDIF
      *
      *
      * Update MIBC02 & MXBC02 with MIOC02 & MAOC02 onverted to Base Currency
      * - MIOC02 (Minimum Charge Other Currency Range 2)
      * - MAOC02 (Maximum Charge Other Currency Range 2)
      * - MIBC02 (Minimum Charge Base Currency Range 2)
      * - MXBC02 (Maximum Charge Base Currency Range 2)
      *
      *
     C                   IF        MIOC02 <> 0   AND MAOC02 <> 0
      *
      * - Minimum Charge 2 (MIBC02 = MIOC02 converted to base currency)
     C                   EVAL      INPAMT = MIOC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC02 = OUTAMT
      *
      * - Maximum Charge 2 (MXBC02 = MAOC02 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC02 = OUTAMT
     C                   ENDIF
      *
      * Update SABC03 & EABC03 with STOC03 & ENOC03 onverted to Base Currency
      * - STOC03 (Start Other Currency Range 3)
      * - ENOC03 (End Other Currency Range 3)
      * - SABC03 (Start Amount Base Currency Range 3)
      * - EABC03 (End Amount Base currency Range 3)
      *
     C                   IF        STOC03 <> 0   AND ENOC03 <> 0
      *
      * - Start Range 3  (SABC03 = STOC03 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC03 = OUTAMT
      *
      * - End Range 3  (EABC03 = ENOC03 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC03 = OUTAMT
     C                   ENDIF
      *
      *
      * Update MIBC03 & MXBC03 with MIOC03 & MAOC03 onverted to Base Currency
      * - MIOC03 (Minimum Charge Other Currency Range 3)
      * - MAOC03 (Maximum Charge Other Currency Range 3)
      * - MIBC03 (Minimum Charge Base Currency Range 3)
      * - MXBC03 (Maximum Charge Base Currency Range 3)
      *
      *
     C                   IF        MIOC03 <> 0   AND MAOC03 <> 0
      *
      * - Minimum Charge 3 (MIBC03 = MIOC03 converted to base currency)
     C                   EVAL      INPAMT = MIOC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC03 = OUTAMT
      *
      * - Maximum Charge 3 (MXBC03 = MAOC03 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC03 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SABC04 & EABC04 with STOC04 & ENOC04 onverted to Base Currency
      * - STOC04 (Start Other Currency Range 4)
      * - ENOC04 (End Other Currency Range 4)
      * - SABC04 (Start Amount Base Currency Range 4)
      * - EABC04 (End Amount Base currency Range 4)
      *
     C                   IF        STOC04 <> 0   AND ENOC04 <> 0
      *
      * - Start Range 4  (SABC04 = STOC04 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC04 = OUTAMT
      *
      * - End Range 4  (EABC04 = ENOC04 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC04 = OUTAMT
     C                   ENDIF
      *
      *
      * Update MIBC04 & MXBC04 with MIOC04 & MAOC04 onverted to Base Currency
      * - MIOC04 (Minimum Charge Other Currency Range 4)
      * - MAOC04 (Maximum Charge Other Currency Range 4)
      * - MIBC04 (Minimum Charge Base Currency Range 4)
      * - MXBC04 (Maximum Charge Base Currency Range 4)
      *
      *
     C                   IF        MIOC04 <> 0   AND MAOC04 <> 0
      *
      * - Minimum Charge 4 (MIBC04 = MIOC04 converted to base currency)
     C                   EVAL      INPAMT = MIOC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC04 = OUTAMT
      *
      * - Maximum Charge 4 (MXBC04 = MAOC04 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC04 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SABC05 & EABC05 with STOC05 & ENOC05 onverted to Base Currency
      * - STOC05 (Start Other Currency Range 5)
      * - ENOC05 (End Other Currency Range 5)
      * - SABC05 (Start Amount Base Currency Range 5)
      * - EABC05 (End Amount Base currency Range 5)
      *
     C                   IF        STOC05 <> 0   AND ENOC05 <> 0
      *
      * - Start Range 5  (SABC05 = STOC05 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC05 = OUTAMT
      *
      * - End Range 5  (EABC05 = ENOC05 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC05 = OUTAMT
     C                   ENDIF
      *
      *
      * Update MIBC05 & MXBC05 with MIOC05 & MAOC05 onverted to Base Currency
      * - MIOC05 (Minimum Charge Other Currency Range 5)
      * - MAOC05 (Maximum Charge Other Currency Range 5)
      * - MIBC05 (Minimum Charge Base Currency Range 5)
      * - MXBC05 (Maximum Charge Base Currency Range 5)
      *
      *
     C                   IF        MIOC05 <> 0   AND MAOC05 <> 0
      *
      * - Minimum Charge 5 (MIBC05 = MIOC05 converted to base currency)
     C                   EVAL      INPAMT = MIOC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC05 = OUTAMT
      *
      * - Maximum Charge 5 (MXBC05 = MAOC05 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC05 = OUTAMT
     C                   ENDIF
      *
      * Update SABC06 & EABC06 with STOC06 & ENOC06 onverted to Base Currency
      * - STOC06 (Start Other Currency Range 6)
      * - ENOC06 (End Other Currency Range 6)
      * - SABC06 (Start Amount Base Currency Range 6)
      * - EABC06 (End Amount Base currency Range 6)
      *
     C                   IF        STOC06 <> 0   AND ENOC06 <> 0
      *
      * - Start Range 6  (SABC06 = STOC06 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC06 = OUTAMT
      *
      * - End Range 6  (EABC06 = ENOC06 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC06 = OUTAMT
     C                   ENDIF
      *
      *
      * Update MIBC06 & MXBC06 with MIOC06 & MAOC06 onverted to Base Currency
      * - MIOC06 (Minimum Charge Other Currency Range 6)
      * - MAOC06 (Maximum Charge Other Currency Range 6)
      * - MIBC06 (Minimum Charge Base Currency Range 6)
      * - MXBC06 (Maximum Charge Base Currency Range 6)
      *
      *
     C                   IF        MIOC06 <> 0   AND MAOC06 <> 0
      *
      * - Minimum Charge 6 (MIBC06 = MIOC06 converted to base currency)
     C                   EVAL      INPAMT = MIOC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC06 = OUTAMT
      *
      * - Maximum Charge 6 (MXBC06 = MAOC06 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC06 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SABC07 & EABC07 with STOC07 & ENOC07 onverted to Base Currency
      * - STOC07 (Start Other Currency Range 7)
      * - ENOC07 (End Other Currency Range 7)
      * - SABC07 (Start Amount Base Currency Range 7)
      * - EABC07 (End Amount Base currency Range 7)
      *
     C                   IF        STOC07 <> 0   AND ENOC07 <> 0                        B* Charge 7
      *
      * - Start Range 7  (SABC07 = STOC07 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC07 = OUTAMT
      *
      * - End Range 7  (EABC07 = ENOC07 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC07 = OUTAMT
     C                   END                                                            E* Charge 7
      *
      *
      * Update MIBC07 & MXBC07 with MIOC07 & MAOC07 onverted to Base Currency
      * - MIOC07 (Minimum Charge Other Currency Range 7)
      * - MAOC07 (Maximum Charge Other Currency Range 7)
      * - MIBC07 (Minimum Charge Base Currency Range 7)
      * - MXBC07 (Maximum Charge Base Currency Range 7)
      *
      *
     C                   IF        MIOC07 <> 0   AND MAOC07 <> 0
      *
      * - Minimum Charge 7 (MIBC07 = MIOC07 converted to base currency)
     C                   EVAL      INPAMT = MIOC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC07 = OUTAMT
      *
      * - Maximum Charge 7 (MXBC07 = MAOC07 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC07 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SABC08 & EABC08 with STOC08 & ENOC08 onverted to Base Currency
      * - STOC08 (Start Other Currency Range 8)
      * - ENOC08 (End Other Currency Range 8)
      * - SABC08 (Start Amount Base Currency Range 8)
      * - EABC08 (End Amount Base currency Range 8)
      *
     C                   IF        STOC08 <> 0   AND ENOC08 <> 0                        B* Charge 8
      *
      * - Start Range 8  (SABC08 = STOC08 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC08 = OUTAMT
      *
      * - End Range 8  (EABC08 = ENOC08 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC08 = OUTAMT
     C                   END                                                            E* Charge 8
      *
      *
      * Update MIBC08 & MXBC08 with MIOC08 & MAOC08 onverted to Base Currency
      * - MIOC08 (Minimum Charge Other Currency Range 8)
      * - MAOC08 (Maximum Charge Other Currency Range 8)
      * - MIBC08 (Minimum Charge Base Currency Range 8)
      * - MXBC08 (Maximum Charge Base Currency Range 8)
      *
      *
     C                   IF        MIOC08 <> 0   AND MAOC08 <> 0
      *
      * - Minimum Charge 8 (MIBC08 = MIOC08 converted to base currency)
     C                   EVAL      INPAMT = MIOC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC08 = OUTAMT
      *
      * - Maximum Charge 8 (MXBC08 = MAOC08 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC08 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SABC09 & EABC09 with STOC09 & ENOC09 onverted to Base Currency
      * - STOC09 (Start Other Currency Range 9)
      * - ENOC09 (End Other Currency Range 9)
      * - SABC09 (Start Amount Base Currency Range 9)
      * - EABC09 (End Amount Base currency Range 9)
      *
     C                   IF        STOC09 <> 0   AND ENOC09 <> 0                        B* Charge 9
      *
      * - Start Range 9  (SABC09 = STOC09 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC09 = OUTAMT
      *
      * - End Range 9  (EABC09 = ENOC09 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC09 = OUTAMT
     C                   END                                                            E* Charge 9
      *
      *
      * Update MIBC09 & MXBC09 with MIOC09 & MAOC09 onverted to Base Currency
      * - MIOC09 (Minimum Charge Other Currency Range 9)
      * - MAOC09 (Maximum Charge Other Currency Range 9)
      * - MIBC09 (Minimum Charge Base Currency Range 9)
      * - MXBC09 (Maximum Charge Base Currency Range 9)
      *
      *
     C                   IF        MIOC09 <> 0   AND MAOC09 <> 0
      *
      * - Minimum Charge 9 (MIBC09 = MIOC09 converted to base currency)
     C                   EVAL      INPAMT = MIOC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC09 = OUTAMT
      *
      * - Maximum Charge 9 (MXBC09 = MAOC09 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC09 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SABC10 & EABC10 with STOC10 & ENOC10 onverted to Base Currency
      * - STOC10 (Start Other Currency Range 10)
      * - ENOC10 (End Other Currency Range 10)
      * - SABC10 (Start Amount Base Currency Range 10)
      * - EABC10 (End Amount Base currency Range 10)
      *
     C                   IF        STOC10 <> 0   AND ENOC10 <> 0                        B* Charge 10
      *
      * - Start Range 10 (SABC10 = STOC10 converted to base ccy)
      *
     C                   EVAL      INPAMT = STOC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SABC10 = OUTAMT
      *
      * - End Range 10 (EABC10 = ENOC10 converted to base currency)
      *
     C                   EVAL      INPAMT = ENOC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      EABC10 = OUTAMT
     C                   END                                                            E* Charge 10
      *
      *
      * Update MIBC10 & MXBC10 with MIOC10 & MAOC10 onverted to Base Currency
      * - MIOC10 (Minimum Charge Other Currency Range 10)
      * - MAOC10 (Maximum Charge Other Currency Range 10)
      * - MIBC10 (Minimum Charge Base Currency Range 10)
      * - MXBC10 (Maximum Charge Base Currency Range 10)
      *
      *
     C                   IF        MIOC10 <> 0   AND MAOC10 <> 0
      *
      * - Minimum Charge 10 (MIBC10 = MIOC10 converted to base currency)
     C                   EVAL      INPAMT = MIOC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MIBC10 = OUTAMT
      *
      * - Maximum Charge 10 (MXBC10 = MAOC10 converted to base currency)
      *
     C                   EVAL      INPAMT = MAOC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      MXBC10 = OUTAMT
     C                   ENDIF
      *
      * Endsr
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SrChgST - Convert STP Charges                                 *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: GETBAS                                                 *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     SrChgST       BEGSR
      *    *******
      *
      * Update SSBC01 & SSEC01 with SSOC01 & SEOC01 onverted to Base Currency
      * - SSOC01 (Start Other Currency Range 1)
      * - SEOC01 (End Other Currency Range 1)
      * - SSBC01 (Start Amount Base Currency Range 1)
      * - SSEC01 (End Amount Base currency Range 1)
      *
     C                   IF        SSOC01 <> 0   AND SEOC01 <> 0                        B* Charge 1
      *
      * - Start Range 1  (SSBC01 = SSOC01 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC01 = OUTAMT
      *
      * - End Range 1  (SSEC01 = SEOC01 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC01 = OUTAMT
     C                   END                                                            E* Charge 1
      *
      *
      * Update SMIB01 & SMAB01 with SMIO01 & SMAC01 onverted to Base Currency
      * - SMIO01 (Minimum Charge Other Currency Range 1)
      * - SMAC01 (Maximum Charge Other Currency Range 1)
      * - SMIB01 (Minimum Charge Base Currency Range 1)
      * - SMAB01 (Maximum Charge Base Currency Range 1)
      *
      *
     C                   IF        SMIO01 <> 0   AND SMAC01 <> 0
      *
      * - Minimum Charge 1 (SMIB01 = SMIO01 converted to base currency)
     C                   EVAL      INPAMT = SMIO01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB01 = OUTAMT
      *
      * - Maximum Charge 1 (SMAB01 = SMAC01 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC01
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB01 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC02 & SSEC02 with SSOC02 & SEOC02 onverted to Base Currency
      * - SSOC02 (Start Other Currency Range 2)
      * - SEOC02 (End Other Currency Range 2)
      * - SSBC02 (Start Amount Base Currency Range 2)
      * - SSEC02 (End Amount Base currency Range 2)
      *
     C                   IF        SSOC02 <> 0   AND SEOC02 <> 0                        B* Charge 2
      *
      * - Start Range 2  (SSBC02 = SSOC02 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC02 = OUTAMT
      *
      * - End Range 2  (SSEC02 = SEOC02 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC02 = OUTAMT
     C                   END                                                            E* Charge 2
      *
      *
      * Update SMIB02 & SMAB02 with SMIO02 & SMAC02 onverted to Base Currency
      * - SMIO02 (Minimum Charge Other Currency Range 2)
      * - SMAC02 (Maximum Charge Other Currency Range 2)
      * - SMIB02 (Minimum Charge Base Currency Range 2)
      * - SMAB02 (Maximum Charge Base Currency Range 2)
      *
      *
     C                   IF        SMIO02 <> 0   AND SMAC02 <> 0
      *
      * - Minimum Charge 2 (SMIB02 = SMIO02 converted to base currency)
     C                   EVAL      INPAMT = SMIO02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB02 = OUTAMT
      *
      * - Maximum Charge 2 (SMAB02 = SMAC02 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC02
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB02 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC03 & SSEC03 with SSOC03 & SEOC03 onverted to Base Currency
      * - SSOC03 (Start Other Currency Range 3)
      * - SEOC03 (End Other Currency Range 3)
      * - SSBC03 (Start Amount Base Currency Range 3)
      * - SSEC03 (End Amount Base currency Range 3)
      *
     C                   IF        SSOC03 <> 0   AND SEOC03 <> 0                        B* Charge 3
      *
      * - Start Range 3  (SSBC03 = SSOC03 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC03 = OUTAMT
      *
      * - End Range 3  (SSEC03 = SEOC03 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC03 = OUTAMT
     C                   END                                                            E* Charge 3
      *
      *
      * Update SMIB03 & SMAB03 with SMIO03 & SMAC03 onverted to Base Currency
      * - SMIO03 (Minimum Charge Other Currency Range 3)
      * - SMAC03 (Maximum Charge Other Currency Range 3)
      * - SMIB03 (Minimum Charge Base Currency Range 3)
      * - SMAB03 (Maximum Charge Base Currency Range 3)
      *
      *
     C                   IF        SMIO03 <> 0   AND SMAC03 <> 0
      *
      * - Minimum Charge 3 (SMIB03 = SMIO03 converted to base currency)
     C                   EVAL      INPAMT = SMIO03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB03 = OUTAMT
      *
      * - Maximum Charge 3 (SMAB03 = SMAC03 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC03
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB03 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC04 & SSEC04 with SSOC04 & SEOC04 onverted to Base Currency
      * - SSOC04 (Start Other Currency Range 4)
      * - SEOC04 (End Other Currency Range 4)
      * - SSBC04 (Start Amount Base Currency Range 4)
      * - SSEC04 (End Amount Base currency Range 4)
      *
     C                   IF        SSOC04 <> 0   AND SEOC04 <> 0                        B* Charge 4
      *
      * - Start Range 4  (SSBC04 = SSOC04 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC04 = OUTAMT
      *
      * - End Range 4  (SSEC04 = SEOC04 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC04 = OUTAMT
     C                   END                                                            E* Charge 4
      *
      *
      * Update SMIB04 & SMAB04 with SMIO04 & SMAC04 onverted to Base Currency
      * - SMIO04 (Minimum Charge Other Currency Range 4)
      * - SMAC04 (Maximum Charge Other Currency Range 4)
      * - SMIB04 (Minimum Charge Base Currency Range 4)
      * - SMAB04 (Maximum Charge Base Currency Range 4)
      *
      *
     C                   IF        SMIO04 <> 0   AND SMAC04 <> 0
      *
      * - Minimum Charge 4 (SMIB04 = SMIO04 converted to base currency)
     C                   EVAL      INPAMT = SMIO04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB04 = OUTAMT
      *
      * - Maximum Charge 4 (SMAB04 = SMAC04 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC04
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB04 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC05 & SSEC05 with SSOC05 & SEOC05 onverted to Base Currency
      * - SSOC05 (Start Other Currency Range 5)
      * - SEOC05 (End Other Currency Range 5)
      * - SSBC05 (Start Amount Base Currency Range 5)
      * - SSEC05 (End Amount Base currency Range 5)
      *
     C                   IF        SSOC05 <> 0   AND SEOC05 <> 0                        B* Charge 5
      *
      * - Start Range 5  (SSBC05 = SSOC05 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC05 = OUTAMT
      *
      * - End Range 5  (SSEC05 = SEOC05 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC05 = OUTAMT
     C                   END                                                            E* Charge 5
      *
      *
      * Update SMIB05 & SMAB05 with SMIO05 & SMAC05 onverted to Base Currency
      * - SMIO05 (Minimum Charge Other Currency Range 5)
      * - SMAC05 (Maximum Charge Other Currency Range 5)
      * - SMIB05 (Minimum Charge Base Currency Range 5)
      * - SMAB05 (Maximum Charge Base Currency Range 5)
      *
      *
     C                   IF        SMIO05 <> 0   AND SMAC05 <> 0
      *
      * - Minimum Charge 5 (SMIB05 = SMIO05 converted to base currency)
     C                   EVAL      INPAMT = SMIO05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB05 = OUTAMT
      *
      * - Maximum Charge 5 (SMAB05 = SMAC05 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC05
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB05 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC06 & SSEC06 with SSOC06 & SEOC06 onverted to Base Currency
      * - SSOC06 (Start Other Currency Range 6)
      * - SEOC06 (End Other Currency Range 6)
      * - SSBC06 (Start Amount Base Currency Range 6)
      * - SSEC06 (End Amount Base currency Range 6)
      *
     C                   IF        SSOC06 <> 0   AND SEOC06 <> 0                        B* Charge 6
      *
      * - Start Range 6  (SSBC06 = SSOC06 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC06 = OUTAMT
      *
      * - End Range 6  (SSEC06 = SEOC06 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC06 = OUTAMT
     C                   END                                                            E* Charge 6
      *
      *
      * Update SMIB06 & SMAB06 with SMIO06 & SMAC06 onverted to Base Currency
      * - SMIO06 (Minimum Charge Other Currency Range 6)
      * - SMAC06 (Maximum Charge Other Currency Range 6)
      * - SMIB06 (Minimum Charge Base Currency Range 6)
      * - SMAB06 (Maximum Charge Base Currency Range 6)
      *
      *
     C                   IF        SMIO06 <> 0   AND SMAC06 <> 0
      *
      * - Minimum Charge 6 (SMIB06 = SMIO06 converted to base currency)
     C                   EVAL      INPAMT = SMIO06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB06 = OUTAMT
      *
      * - Maximum Charge 6 (SMAB06 = SMAC06 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC06
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB06 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC07 & SSEC07 with SSOC07 & SEOC07 onverted to Base Currency
      * - SSOC07 (Start Other Currency Range 7)
      * - SEOC07 (End Other Currency Range 7)
      * - SSBC07 (Start Amount Base Currency Range 7)
      * - SSEC07 (End Amount Base currency Range 7)
      *
     C                   IF        SSOC07 <> 0   AND SEOC07 <> 0                        B* Charge 7
      *
      * - Start Range 7  (SSBC07 = SSOC07 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC07 = OUTAMT
      *
      * - End Range 7  (SSEC07 = SEOC07 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC07 = OUTAMT
     C                   END                                                            E* Charge 7
      *
      *
      * Update SMIB07 & SMAB07 with SMIO07 & SMAC07 onverted to Base Currency
      * - SMIO07 (Minimum Charge Other Currency Range 7)
      * - SMAC07 (Maximum Charge Other Currency Range 7)
      * - SMIB07 (Minimum Charge Base Currency Range 7)
      * - SMAB07 (Maximum Charge Base Currency Range 7)
      *
      *
     C                   IF        SMIO07 <> 0   AND SMAC07 <> 0
      *
      * - Minimum Charge 7 (SMIB07 = SMIO07 converted to base currency)
     C                   EVAL      INPAMT = SMIO07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB07 = OUTAMT
      *
      * - Maximum Charge 7 (SMAB07 = SMAC07 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC07
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB07 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC08 & SSEC08 with SSOC08 & SEOC08 onverted to Base Currency
      * - SSOC08 (Start Other Currency Range 8)
      * - SEOC08 (End Other Currency Range 8)
      * - SSBC08 (Start Amount Base Currency Range 8)
      * - SSEC08 (End Amount Base currency Range 8)
      *
     C                   IF        SSOC08 <> 0   AND SEOC08 <> 0                        B* Charge 8
      *
      * - Start Range 8  (SSBC08 = SSOC08 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC08 = OUTAMT
      *
      * - End Range 8  (SSEC08 = SEOC08 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC08 = OUTAMT
     C                   END                                                            E* Charge 8
      *
      *
      * Update SMIB08 & SMAB08 with SMIO08 & SMAC08 onverted to Base Currency
      * - SMIO08 (Minimum Charge Other Currency Range 8)
      * - SMAC08 (Maximum Charge Other Currency Range 8)
      * - SMIB08 (Minimum Charge Base Currency Range 8)
      * - SMAB08 (Maximum Charge Base Currency Range 8)
      *
      *
     C                   IF        SMIO08 <> 0   AND SMAC08 <> 0
      *
      * - Minimum Charge 8 (SMIB08 = SMIO08 converted to base currency)
     C                   EVAL      INPAMT = SMIO08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB08 = OUTAMT
      *
      * - Maximum Charge 8 (SMAB08 = SMAC08 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC08
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB08 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC09 & SSEC09 with SSOC09 & SEOC09 onverted to Base Currency
      * - SSOC09 (Start Other Currency Range 9)
      * - SEOC09 (End Other Currency Range 9)
      * - SSBC09 (Start Amount Base Currency Range 9)
      * - SSEC09 (End Amount Base currency Range 9)
      *
     C                   IF        SSOC09 <> 0   AND SEOC09 <> 0                        B* Charge 9
      *
      * - Start Range 9  (SSBC09 = SSOC09 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC09 = OUTAMT
      *
      * - End Range 9  (SSEC09 = SEOC09 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC09 = OUTAMT
     C                   END                                                            E* Charge 9
      *
      *
      * Update SMIB09 & SMAB09 with SMIO09 & SMAC09 onverted to Base Currency
      * - SMIO09 (Minimum Charge Other Currency Range 9)
      * - SMAC09 (Maximum Charge Other Currency Range 9)
      * - SMIB09 (Minimum Charge Base Currency Range 9)
      * - SMAB09 (Maximum Charge Base Currency Range 9)
      *
      *
     C                   IF        SMIO09 <> 0   AND SMAC09 <> 0
      *
      * - Minimum Charge 9 (SMIB09 = SMIO09 converted to base currency)
     C                   EVAL      INPAMT = SMIO09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB09 = OUTAMT
      *
      * - Maximum Charge 9 (SMAB09 = SMAC09 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC09
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB09 = OUTAMT
     C                   ENDIF
      *
      *
      * Update SSBC10 & SSEC10 with SSOC10 & SEOC10 onverted to Base Currency
      * - SSOC10 (Start Other Currency Range 10)
      * - SEOC10 (End Other Currency Range 10)
      * - SSBC10 (Start Amount Base Currency Range 10)
      * - SSEC10 (End Amount Base currency Range 10)
      *
     C                   IF        SSOC10 <> 0   AND SEOC10 <> 0                       B* Charge 10
      *
      * - Start Range 10 (SSBC10 = SSOC10 converted to base ccy)
      *
     C                   EVAL      INPAMT = SSOC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSBC10 = OUTAMT
      *
      * - End Range 10 (SSEC10 = SEOC10 converted to base currency)
      *
     C                   EVAL      INPAMT = SEOC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SSEC10 = OUTAMT
     C                   END                                                           E* Charge 10
      *
      *
      * Update SMIB10 & SMAB10 with SMIO10 & SMAC10 onverted to Base Currency
      * - SMIO10 (Minimum Charge Other Currency Range 10)
      * - SMAC10 (Maximum Charge Other Currency Range 10)
      * - SMIB10 (Minimum Charge Base Currency Range 10)
      * - SMAB10 (Maximum Charge Base Currency Range 10)
      *
      *
     C                   IF        SMIO10 <> 0   AND SMAC10 <> 0
      *
      * - Minimum Charge 10 (SMIB10 = SMIO10 converted to base currency)
     C                   EVAL      INPAMT = SMIO10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMIB10 = OUTAMT
      *
      * - Maximum Charge 10 (SMAB10 = SMAC10 converted to base currency)
      *
     C                   EVAL      INPAMT = SMAC10
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SMAB10 = OUTAMT
     C                   ENDIF
      *
      *
      * Endsr
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SrChgOB - Convert Out of Band Charges                         *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: GETBAS                                                 *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     SrChgOB       BEGSR
      *    *******
      *
      * Update OMIBC & OMABC with OMIOC & OMAOC converted to Base Currency
      * - OMIOC (Out of band minimun Other Currency)
      * - OMAOC (Out of band maximum Other Currency)
      * - OMIBC (Out of band minimum Base Currency)
      * - OMABC (Out of band maximum Base Currency
      *
      * - Minimum (OMIBC = OMIOC converted to base ccy)
      *
     C                   IF        OMIOC  <> 0                                        B* Out of Band
     C                   EVAL      INPAMT = OMIOC
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      OMIBC = OUTAMT
     C                   END                                                          E* Out of Band
      *
      * - Maximum (OMABC = OMAOC converted to base currency)
      *
     C                   IF        OMAOC  <> 0                                        B* Out of Band
     C                   EVAL      INPAMT = OMAOC
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      OMABC = OUTAMT
     C                   END                                                          E* Out of Band
      *
      *
      *
      * Update SOMIBC & SMABC with SOMIOC & SOMAOC converted to Base Currency
      * - SOMIOC (Out of band minimun Other Currency)
      * - SOMAOC (Out of band maximum Other Currency)
      * - SOMIBC (Out of band minimum Base Currency)
      * - SOMABC (Out of band maximum Base Currency
      *
      *
      * - Minimum (SOMIBC = SOMIOC converted to base ccy)
      *
     C                   IF        SOMIOC  <> 0                                       B* Out of Band
     C                   EVAL      INPAMT = SOMIOC
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SOMIBC = OUTAMT
     C                   END                                                          E* Out of Band
      *
      * - Maximum (SOMABC = SOMAOC converted to base currency)
      *
     C                   IF        SOMAOC  <> 0                                       B* Out of Band
     C                   EVAL      INPAMT = SOMAOC
     C                   EVAL      FRMCCY = OTHCCY
     C                   EVAL      TOCCY  = #Basccy
 
     C                   EXSR      GETBAS
 
     C                   EVAL      SOMABC = OUTAMT
     C                   END                                                          E* Out of Band
      *
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * SrAdjMA - Adjust Manual Charges                               *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     SrAdjMA       BEGSR
      *    *******
      *
      *
      * - SABC02 (Start Amount Base Currency Range 1)
      * - EABC01 (End Amount Base currency Range 1)
     C                   IF        SABC02 <> EABC01 + #Diff1 and SABC02 <> 0
     C                   EVAL      SABC02 =  EABC01 + #Diff1
     C                   END
      *
      *
      * - SABC03 (Start Amount Base Currency Range 3)
      * - EABC02 (End Amount Base currency Range 2)
     C                   IF        SABC03 <> EABC02 + #Diff1 and SABC03 <> 0
     C                   EVAL      SABC03 =  EABC02 + #Diff1
     C                   END
      *
      * - SABC04 (Start Amount Base Currency Range 4)
      * - EABC03 (End Amount Base currency Range 3)
     C                   IF        SABC04 <> EABC03 + #Diff1  and SABC04 <> 0
     C                   EVAL      SABC04 =  EABC03 + #Diff1
     C                   END
      *
      *
      * - SABC05 (Start Amount Base Currency Range 5)
      * - EABC04 (End Amount Base currency Range 4)
     C                   IF        SABC05 <> EABC04 + #Diff1 and SABC05 <> 0
     C                   EVAL      SABC05 =  EABC04 + #Diff1
     C                   END
      *
      *
      * - SABC06 (Start Amount Base Currency Range 6)
      * - EABC05 (End Amount Base currency Range 5)
     C                   IF        SABC06 <> EABC05 + #Diff1 and SABC06 <> 0
     C                   EVAL      SABC06 =  EABC05 + #Diff1
     C                   END
      *
      *
      * - SABC07 (Start Amount Base Currency Range 7)
      * - EABC06 (End Amount Base currency Range 6)
     C                   IF        SABC07 <> EABC06 + #Diff1 and SABC07 <> 0
     C                   EVAL      SABC07 =  EABC06 + #Diff1
     C                   END
      *
      *
      * - SABC08 (Start Amount Base Currency Range 8)
      * - EABC07 (End Amount Base currency Range 7)
     C                   IF        SABC08 <> EABC07 + #Diff1 and SABC08 <> 0
     C                   EVAL      SABC08 =  EABC07 + #Diff1
     C                   END
      *
      *
      * - SABC09 (Start Amount Base Currency Range 9)
      * - EABC08 (End Amount Base currency Range 8)
     C                   IF        SABC09 <> EABC08 + #Diff1 and SABC09 <> 0
     C                   EVAL      SABC09 =  EABC08 + #Diff1
     C                   END
      *
      *
      * - SABC10 (Start Amount Base Currency Range 10)
      * - EABC09 (End Amount Base currency Range 9)
     C                   IF        SABC10 <> EABC09 + #Diff1 and SABC10 <> 0
     C                   EVAL      SABC10 =  EABC09 + #Diff1
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * SrAdjST - Adjust STP Charges                                  *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
      *    *******
     C     SrAdjST       BEGSR
      *    *******
      *
      *
      * - SSBC02 (Start Amount Base Currency Range 1)
      * - SSEC01 (End Amount Base currency Range 1)
     C                   IF        SSBC02 <> SSEC01 + #Diff1 and SSBC02 <> 0
     C                   EVAL      SSBC02 =  SSEC01 + #Diff1
     C                   END
      *
      *
      * - SSBC03 (Start Amount Base Currency Range 3)
      * - SSEC02 (End Amount Base currency Range 2)
     C                   IF        SSBC03 <> SSEC02 + #Diff1 and SSBC03 <> 0
     C                   EVAL      SSBC03 =  SSEC02 + #Diff1
     C                   END
      *
      *
      * - SSBC04 (Start Amount Base Currency Range 4)
      * - SSEC03 (End Amount Base currency Range 3)
     C                   IF        SSBC04 <> SSEC03 + #Diff1 and SSBC04 <> 0
     C                   EVAL      SSBC04 =  SSEC03 + #Diff1
     C                   END
      *
      *
      *
      * - SSBC05 (Start Amount Base Currency Range 5)
      * - SSEC04 (End Amount Base currency Range 4)
     C                   IF        SSBC05 <> SSEC04 + #Diff1 and SSBC05 <> 0
     C                   EVAL      SSBC05 =  SSEC04 + #Diff1
     C                   END
      *
      *
      * - SSBC06 (Start Amount Base Currency Range 6)
      * - SSEC05 (End Amount Base currency Range 5)
     C                   IF        SSBC06 <> SSEC05 + #Diff1 and SSBC06 <> 0
     C                   EVAL      SSBC06 =  SSEC05 + #Diff1
     C                   END
      *
      *
      * - SSBC07 (Start Amount Base Currency Range 7)
      * - SSEC06 (End Amount Base currency Range 6)
     C                   IF        SSBC07 <> SSEC06 + #Diff1 and SSBC07 <> 0
     C                   EVAL      SSBC07 =  SSEC06 + #Diff1
     C                   END
      *
      *
      * - SSBC08 (Start Amount Base Currency Range 8)
      * - SSEC07 (End Amount Base currency Range 7)
     C                   IF        SSBC08 <> SSEC07 + #Diff1 and SSBC08 <> 0
     C                   EVAL      SSBC08 =  SSEC07 + #Diff1
     C                   END
      *
      *
      * - SSBC09 (Start Amount Base Currency Range 9)
      * - SSEC08 (End Amount Base currency Range 8)
     C                   IF        SSBC09 <> SSEC08 + #Diff1 and SSBC09 <> 0
     C                   EVAL      SSBC09 =  SSEC08 + #Diff1
     C                   END
      *
      *
      * - SSBC10 (Start Amount Base Currency Range 10)
      * - SSEC09 (End Amount Base currency Range 9)
     C                   IF        SSBC10 <> SSEC09 + #Diff1 and SSBC10 <> 0
     C                   EVAL      SSBC10 =  SSEC09 + #Diff1
     C                   END
      *
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * DECIMALS - Get number of decimal places for currency          *
      *                                                               *
      * Called by: MOVFIL *INZSR                                      *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
      *    ********
     C     DECIMALS      BEGSR
      *    ********
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       #RTCD
     C                   PARM      '*KEY   '     #OPTN
     C                   PARM                    #ccyA
     C     SDCURR        PARM      SDCURR        DSSDY
 
      * If #RTCD = *NRF then set decimals to 0 for screen formatting.
     C                   IF        #RTCD = '*NRF   '
     C                   EVAL      A6NBDP = 0
     C                   ENDIF
 
     C                   ENDSR
 
 
      *****************************************************************
      *                                                               *
      * GETBAS - Get base ccy amount                                  *
      *                                                               *
      * Called by: VALIDATE                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     GETBAS        BEGSR
 
      *
      * Calculate base currency equivalent
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      FRMCCY        @CCY
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *LIKE         DEFINE    A6NBDP        BASDEC
     C                   MOVEL     A6NBDP        BASDEC
     C     *LIKE         DEFINE    A6MDIN        BASMD
     C                   MOVEL     A6MDIN        BASMD
     C     *LIKE         DEFINE    A6SPRT        CVTRAT
     C                   MOVEL     A6SPRT        CVTRAT
      *
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      TOCCY         @CCY              3
     C     SDCURR        PARM      SDCURR        DSFDY
      *
     C     *like         DEFINE    A6NBDP        TODEC
     C                   MOVEL     A6NBDP        TODEC
 
     C                   CALL      'ZCONVZ1'
     C                   PARM                    INPAMT           15 0
     C                   PARM                    CVTRAT
     C                   PARM                    BASMD
     C                   PARM                    FRMCCY            3
     C                   PARM                    TOCCY             3
     C                   PARM                    BASDEC
     C                   PARM                    TODEC
     C                   PARM      *ZEROS        OUTAMT           15 0
 
     C                   ENDSR
 
 
 
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Initial processing                                 *
      *                                                               *
      * Calls: *PSSR DECIMALS                                         *
      *                                                               *
      *****************************************************************
 
      *    ******
     C     *INZSR        BEGSR
      *    ******
 
     C                   MOVE      '1'           #Diff1
      *
 
      * Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Database error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ELSE
      * Base currency details
     C                   EVAL      #Ccya  =  BJCYCD
     C                   EXSR      DECIMALS
     C                   EVAL      #Basccy =  BJCYCD
     C                   EVAL      #Basdec = A6NBDP
     C                   EVAL      #Basint = 13 - #Basdec
     C                   EVAL      #Basmd = A6MDIN
     C                   ENDIF
 
 
      *********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
     C/COPY ZACPYSRC,PSSR_ILE
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2014
