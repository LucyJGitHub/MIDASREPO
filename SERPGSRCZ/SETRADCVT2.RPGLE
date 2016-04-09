     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade conversion file to screen format')      *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADCVT2 - Trades Conversion: X2 File to Screen Format     *
      *                                                               *
      *  Function:  This module converts the fields of a TRADSDX2     *
      *             from their format as on file to a screen format.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW206E            Date 24Aug06               *
      *                 CSW206D            Date 24Aug06               *
      *                 CSE045  *CREATE    Date 14Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  CSW206D - Change Control for SWIFT 2006 Standard Changes     *
      *  CSE045 - API for Extended Settlement for Trade Input and     *
      *           Depot Movement                                      *
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * File Formats
     D TX2AFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(A_)
     D TX2BFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(B_)
     D TX2WFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(W_)
 
      * Screen Formats
     D TrX2ASwft     E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(A_)
     D TrX2BSwft     E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(B_)
     D TrX2WSwft     E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(W_)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D CSW210          S              1A                                                      CSW210
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      **************************************************************
      /EJECT
     C**************************************************************
      *
      * INITIALIZATION
      *
     C                   MOVE      TX2AFilFmt    TX2WFilFmt
     C                   EXSR      MoveFil2Scn
     C                   MOVE      TrX2WSwft     TrX2ASwft
     C                   MOVE      TX2BFilFmt    TX2WFilFmt
     C                   EXSR      MoveFil2Scn
     C                   MOVE      TrX2WSwft     TrX2BSwft
      *
      * Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MoveFil2Scn - Subroutine to move file fields to Screen fields *
      *****************************************************************
     C     MoveFil2Scn   BEGSR
 
     C                   MOVE      W_T2AP1N      W_ESAP1N
     C                   MOVE      W_T2AP1L      W_ESAP1L
     C                   MOVE      W_T2AFPN      W_ESAP2N
     C                   MOVE      W_T2AFPL      W_ESAP2L
     C                   MOVE      W_T2AWIN      W_ESAWIN
     C                   MOVE      W_T2AWIL      W_ESAWIL
     C                   MOVE      W_T2BOFN      W_ESBOFN
     C                   MOVE      W_T2BOF1      W_ESBOF1
     C                   IF        CSW210 = 'N'                                               CSW210
     C                   MOVE      W_T2BOF2      W_ESBOF2
     C                   ENDIF                                                                CSW210
     C                   MOVE      W_T2ACL1      W_ESACL1
     C                   MOVE      W_T2ACL2      W_ESACL2
     C                   MOVE      W_T2SRL1      W_ESSRL1
     C                   MOVE      W_T2SRL2      W_ESSRL2
     C                   MOVE      W_T2SRL3      W_ESSRL3
     C                   MOVE      W_T2FIN1      W_ESFIN1
     C                   MOVE      W_T2FIN2      W_ESFIN2
     C                   MOVE      W_T2RED1      W_ESRED1
     C                   MOVE      W_T2RED2      W_ESRED2
     C                   MOVE      W_T2NAL1      W_ESNAL1
     C                   MOVE      W_T2NAL2      W_ESNAL2
     C                   MOVE      W_T2IPYN      W_ESIPYN
     C                   MOVE      W_T2IPYL      W_ESIPYL
     C                   MOVE      W_T2CTYN      W_ESCTYN
     C                   MOVE      W_T2CTYL      W_ESCTYL
     C                   MOVE      W_T2SA1N      W_ESSA1N
     C                   MOVE      W_T2SA1L      W_ESSA1L
     C                   MOVE      W_T2SKAN      W_ESSKAN
     C                   MOVE      W_T2SKAL      W_ESSKAL
     C                   MOVE      W_T2CCTN      W_ESCCTN
     C                   MOVE      W_T2DCTL      W_ESDCTL
     C                   MOVE      W_T2RSSN      W_ESRSSN
     C                   MOVE      W_T2RSS1      W_ESRSS1
     C                   MOVE      W_T2RSS2      W_ESRSS2
     C                   MOVE      W_T2RSS3      W_ESRSS3
     C                   MOVE      W_T2RSS4      W_ESRSS4
     C                   MOVE      W_T2DSSN      W_ESDSSN
     C                   MOVE      W_T2DSS1      W_ESDSS1
     C                   MOVE      W_T2DSS2      W_ESDSS2
     C                   MOVE      W_T2DSS3      W_ESDSS3
     C                   MOVE      W_T2DSS4      W_ESDSS4
     C                   MOVE      W_T2BSSN      W_ESBSSN
     C                   MOVE      W_T2BSS1      W_ESBSS1
     C                   MOVE      W_T2BSS2      W_ESBSS2
     C                   MOVE      W_T2INVE      W_ESINVE
     C                   MOVE      W_T2IMD1      W_ESIMMD1
     C                   MOVE      W_T2IMS1      W_ESIMSA1
     C                   MOVE      W_T2IMD2      W_ESIMMD2
     C                   MOVE      W_T2IMS2      W_ESIMSA2
     C**********         MOVE      W_T2IMD3      W_ESIMMD3                                   CSW206D
     C**********         MOVE      W_T2IMS3      W_ESIMSA3                                   CSW206D
     C**********         MOVE      W_T2IMD4      W_ESIMMD4                                   CSW206D
     C**********         MOVE      W_T2IMS4      W_ESIMSA4                                   CSW206D
     C**********         MOVE      W_T2IMD5      W_ESIMMD5                                   CSW206D
     C**********         MOVE      W_T2IMS5      W_ESIMSA5                                   CSW206D
     C**********         MOVE      W_T2IMD6      W_ESIMMD6                                   CSW206D
     C**********         MOVE      W_T2IMS6      W_ESIMSA6                                   CSW206D
     C**********         MOVE      W_T2IMD7      W_ESIMMD7                                   CSW206D
     C**********         MOVE      W_T2IMS7      W_ESIMSA7                                   CSW206D
     C**********         MOVE      W_T2IMD8      W_ESIMMD8                                   CSW206D
     C**********         MOVE      W_T2IMS8      W_ESIMSA8                                   CSW206D
     C**********         MOVE      W_T2IMD9      W_ESIMMD9                                   CSW206D
     C**********         MOVE      W_T2IMS9      W_ESIMSA9                                   CSW206D
     C                   IF        CSW206 = 'N'                                              CSW206E
     C                   MOVE      W_T2IMD3      W_ESIMMD3                                   CSW206E
     C                   MOVE      W_T2IMS3      W_ESIMSA3                                   CSW206E
     C                   MOVE      W_T2IMD4      W_ESIMMD4                                   CSW206E
     C                   MOVE      W_T2IMS4      W_ESIMSA4                                   CSW206E
     C                   MOVE      W_T2IMD5      W_ESIMMD5                                   CSW206E
     C                   MOVE      W_T2IMS5      W_ESIMSA5                                   CSW206E
     C                   MOVE      W_T2IMD6      W_ESIMMD6                                   CSW206E
     C                   MOVE      W_T2IMS6      W_ESIMSA6                                   CSW206E
     C                   MOVE      W_T2IMD7      W_ESIMMD7                                   CSW206E
     C                   MOVE      W_T2IMS7      W_ESIMSA7                                   CSW206E
     C                   MOVE      W_T2IMD8      W_ESIMMD8                                   CSW206E
     C                   MOVE      W_T2IMS8      W_ESIMSA8                                   CSW206E
     C                   MOVE      W_T2IMD9      W_ESIMMD9                                   CSW206E
     C                   MOVE      W_T2IMS9      W_ESIMSA9                                   CSW206E
     C                   ENDIF                                                               CSW206E
     C                   MOVE      W_T2PSET      W_ESPSET
     C                   MOVE      W_T2NAC1      W_ESNAC1
     C                   MOVE      W_T2NAC2      W_ESNAC2
     C                   IF        CSW210 = 'Y'                                               CSW210
     C                   MOVE      W_T2DIDN      W_ESDIDN                                     CSW210
     C                   MOVE      W_T2DAD1      W_ESDAD1                                     CSW210
     C                   MOVE      W_T2DAD2      W_ESDAD2                                     CSW210
     C                   MOVE      W_T2DAD3      W_ESDAD3                                     CSW210
     C                   MOVE      W_T2DAD4      W_ESDAD4                                     CSW210
     C                   MOVE      W_T2DLIN      W_ESDLIN                                     CSW210
     C                   MOVE      W_T2QFIN      W_ESQFIN                                     CSW210
     C                   MOVE      W_T2PCLR      W_ESPCLR                                     CSW210
     C                   ENDIF                                                                CSW210
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * File formats
     C                   PARM                    TX2AFilFmt
     C                   PARM                    TX2BFilFmt
     C                   PARM                    CSW206            1                         CSW206E
     C                   PARM                    CSW210                                       CSW210
      *
      * Output parameters
      *
      * Screen formats
     C                   PARM                    TrX2ASwft
     C                   PARM                    TrX2BSwft
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADCVT2'  DBPGM
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
