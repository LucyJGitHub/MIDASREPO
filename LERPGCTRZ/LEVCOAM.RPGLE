     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Correction Amount')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVCOAM - Validate Correction Amount                         *
      *                                                               *
      *  Function:  This module receives a parameter containing an    *
      *             amount and confirm whether it is a correct amount *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
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
      *
      ** External DS for currency details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Correction Amount
      *
     D LCOAM           S             15A
     D LVCOAM          S             15  0
     D LAMNT           S             15S 0
     D LCCY            S              3A
     D BNDCSP          S              1A
      *
      ** Define parameters for call module
      *
     D @@ALPH          S             16A
     D @@IDP           S              3  0
     D @@IINT          S              3  0
     D @@MTID          S              1A
     D @@ERCD          S              1  0
     D @@AMT           S             15  0
     D PNDEC           S              1  0
     D PWRK25          S             25
     D PECODE          S              1A
      *
     D @CCY            S              3A
 
     D POUT            DS
     D  POUT22                 1     22
     D  POUT20                 1     20
     D
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN PROCESSING
      *****************************************************************
      *
      ** Initialization
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ** Validation
      *
      ** Call AOCURRR0 to check the currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      LCCY          @CCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     LCCY          DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        @@IDP
     C     15            SUB       A6NBDP        @@IINT
     C                   MOVE      *BLANKS       @@ALPH
     C                   MOVE      LCOAM         @@ALPH
     C                   MOVE      'Y'           @@MTID
      *
      ** Call the module ZA0840 for validate and align the correction
      ** amount
      *
     C                   CALLB     'ZA0840'
     C                   PARM                    RetCodeOut
     C                   PARM                    @@ALPH
     C                   PARM                    @@IDP
     C                   PARM                    @@IINT
     C                   PARM                    @@MTID
     C                   PARM      *ZERO         @@ERCD
     C                   PARM                    @@AMT
     C                   PARM                    BNDCSP
      *
      ** If error was found in the validation of the correction amount
      *
     C                   IF        @@ERCD <> 0
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID     = 'ER89001'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** If the amount returned is negative
      *
     C                   IF        @@AMT < 0
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID     = 'ER89001'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ** If the amount input is greater than the principal amount
      *
     C                   IF        @@AMT > LAMNT  AND @@AMT <> 0
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID     = 'ER89002'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   EVAL      LVCOAM     = @@AMT
     C                   EVAL      PNDEC      = A6NBDP
     C                   CALLB     'ZFRPED'
     C                   PARM                    LVCOAM
     C                   PARM                    PNDEC
     C                   PARM      'L'           PECODE
     C                   PARM      *BLANKS       POUT22
     C                   PARM      *BLANKS       PWRK25
 
     C                   MOVE      POUT20        LCOAM
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn  = 'Error '
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    LCOAM
     C                   PARM                    LVCOAM
     C                   PARM                    LAMNT
     C                   PARM                    LCCY
      *
      ** Decimal separator (1A, from SDDEALPD, via caller)
      *
     C                   PARM                    BNDCSP
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
** CPY@
(c) Misys International Banking Systems Ltd. 2005
