     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Amortise Over Whole Period Ind.')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVAMRI - Validate Amortise Over Whole Period Indicator      *
      *                                                               *
      *  Function: This function receives a parameter containing      *
      *            amortised over whole period indicator and confirm  *
      *            whether it is a valid entry or not                 *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *               . BUG16539A          Date 27Mar08               *
      *                 BUG16539           Date 03Mar08               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CAS019  *Create    Date 20Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG16539A - Changes made in LEVAMRI, LEVENPD, and LEVSTPD    *
      *              if fee code is adjustment to yield and loan is   *
      *              flagged to do amortised cost accounting.         *
      *  BUG16539 - Error encountered when a linear fee is attached   *
      *             to an amortising type of loan                     *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
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
 
     D TranInPrim    E DS                  EXTNAME(LEFEEMPD)
      * Incoming Transaction
 
     D SDFEE         E DS                  EXTNAME(SDFEEPD)
      ** External DS for Fee Details
 
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ** External DS for Fee Details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
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
 
     C                   RESET                   ErrorFound
     C                   MOVE      *BLANKS       RetCodeIn
 
     C                   EXSR      VAMRI
 
     C                   RETURN
      *****************************************************************
     C/EJECT
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
     C                   PARM                    #MsgID
      *
      ** Field(s) requiring validation
     C                   PARM                    TranInPrim
      *
      ** Information contained in these data structures are needed for validation
     C                   PARM                    SDFEE
     C                   PARM                    SDLOAN
      *
      * OUTPUTS
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      * VAMRI - Validate Amortised over Whole Period Indicator        *
      *****************************************************************
     C     VAMRI         BEGSR
 
      *
      ** Amortised Seperately Indicator will be defaulted to "N" when
      ** entry is blank and loan is flagged to do amortised cost acctg                     BUG16539A
      ** and fee is adjustment to yield                                                    BUG16539A
      ***entry*is*blank*and*loan*is*flagged*to*do*amortised*cost*acctg                      BUG16539
      ***or*fee*is*adjustment*to*yield                                                      BUG16539
 
     C**********         IF        (DDAMRI = *BLANKS  AND AUADJY = 'Y') OR                  BUG16539
     C**********                   (DDAMRI = *BLANKS  AND AYACAI = 'Y')                     BUG16539
     C**********         IF        DDAMRI = *BLANKS                               BUG16539 BUG16539A
     C                   IF        DDAMRI = *BLANKS AND AUADJY = 'Y' AND                   BUG16539A
     C                             AYACAI = 'Y'                                            BUG16539A
     C                   EVAL      DDAMRI = 'N'
     C                   ENDIF
 
      **********                                                                            BUG16539
      ***Amortised*Seperately*Indicator*will*be*defaulted*to**BLANKS                        BUG16539
      ***when*loan*is*not*flagged*to*do*amortised*cost*acctg*and                            BUG16539
      ***fee*is*not*adjustment*to*yield                                                     BUG16539
 
     C**********         IF        (AUADJY = 'N' OR AYACAI = 'N')                           BUG16539
     C**********         EVAL      DDAMRI = *BLANKS                                         BUG16539
     C**********         ENDIF                                                              BUG16539
 
      *
      ** Valid values are "Y", "N" or blanks
 
     C                   IF        (AUADJY = 'Y' AND AYACAI = 'Y') AND
     C                             NOT(DDAMRI = 'Y' OR DDAMRI = 'N')
     C                   EVAL      #MsgID         = 'LER1203'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Error'
     C                   LeaveSR
     C                   ENDIF
 
      *
      ** Entry is valid only when fee code is Adjustment to Yield and
      ** Loan is flagged to do Amortised Cost Accounting
 
     C                   IF        NOT(AUADJY = 'Y' AND AYACAI = 'Y') AND
     C**********                   (DDAMRI = 'Y' OR DDAMRI = 'N')                           BUG16539
     C                             (DDAMRI = 'Y')                                           BUG16539
     C                   EVAL      #MsgID         = 'LER1202'
     C                   EVAL      ErrorFound     = 'Y'
     C                   EVAL      RetCodeIn      = 'Error'
     C                   LeaveSR
     C                   ENDIF
 
      **                                                                                   BUG16539A
      ** Amortised Seperately Indicator will be defaulted to *BLANKS                       BUG16539A
      ** when loan is not flagged to do amortised cost acctg or                            BUG16539A
      ** fee is not adjustment to yield                                                    BUG16539A
                                                                                           BUG16539A
     C                   IF        (AUADJY <> 'Y' OR AYACAI <> 'Y')                        BUG16539A
     C                   EVAL      DDAMRI = *BLANKS                                        BUG16539A
     C                   ENDIF                                                             BUG16539A
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
