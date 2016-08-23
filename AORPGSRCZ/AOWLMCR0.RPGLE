     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Message Concatenation')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOWLMCR0 - Message Concatenation Access Object               *
      *                                                               *
      *  Function:  This program accepts message tags and its value   *
      *             as input.  This will be concatenated to the search*
      *             string to form the data for Compliance Engine     *
      *             Program.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Search for '<' is successful                    *
      *               Search for ' ' is successful                    *
      *    02         Search for '>' is successful                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRReturn      -  Return Error Code and Set Parameters        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
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
 
     D D_RFMT        E DS                  EXTNAME(SDWLCCPD)
      ** File Information Data Structure
 
     D P_RFMT        E DS                  EXTNAME(DSSDY)
      ** External Data Structure to Hold the Outgoing Record Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRetCode        S              7A
     D POption         S              7A
     D PMTag           S              5A
     D PValue          S             50A
     D PSrchStrng      S           9999A
     D WSavMTag        S             10A
     D WSavStrtPos     S              4  0
     D WSavLastPos     S              4  0
     D WStrFnd         S              1A
     D WLstFnd         S              1A
     D C               S              4  0
     D I               S              4  0
     D X               S              4  0
     D Y               S              4  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialise variables
     C                   EXSR      SRInit
 
     C                   IF        PMTAG = *BLANKS
     C                   EXSR      SRPrevTag
     C                   ELSE
     C                   EXSR      SRNewTag
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Initialise necessary variables                      *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      WSavStrtPos = 1
     C                   EVAL      WSavMTag = *BLANKS
     C                   EVAL      C = 1
     C                   EVAL      I = 1
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WStrFnd = ' '
     C                   EVAL      WLstFnd = ' '
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrevTag - Add message value to previous tag                *
      *                                                               *
      *****************************************************************
     C     SRPrevTag     BEGSR
 
     C                   DOU       WStrFnd = 'N'
     C     '<'           SCAN      PSrchStrng:I  C                        01
 
     C                   IF        *IN01 = *ON
     C                   EVAL      WStrFnd = 'Y'
     C                   EVAL      I = C + 1
     C                   EVAL      WSavStrtPos = C
     C                   ELSE
 
     C                   IF        WStrFnd = 'Y'
     C     '>'           SCAN      PSrchStrng:I  C                        02
     C                   IF        *IN02 = *ON
     C                   EVAL      WLstFnd = 'Y'
     C                   EVAL      WSavLastPos = C
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WStrFnd = 'N'
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WLstFnd = 'Y'
     C                   EVAL      X = WSavStrtPos
     C                   EVAL      Y = (WSavLastPos - X) + 1
     C                   EVAL      WSavMTag = %SUBST(PSrchStrng:X:Y)
     C                   EVAL      %SUBST(PSrchStrng:X) = ' ' + %TRIM(PValue) +
     C                               %TRIM(WSavMTag)
     C                   ELSE
     C                   EVAL      %SUBST(PSrchStrng:1) = ' ' + %TRIM(PValue) +
     C                               %TRIM(WSavMTag)
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNewTag - Perform string manipulation for new tag           *
      *                                                               *
      *****************************************************************
     C     SRNewTag      BEGSR
 
     C                   EVAL      WStrFnd = ' '
     C                   EVAL      I = 1
 
     C                   DOU       WStrFnd = 'N'
     C     ' '           SCAN      PSrchStrng:I  C                        01
 
     C                   IF        *IN01 = *ON
     C                   EVAL      I = C + 1
     C                   EVAL      WSavStrtPos = C
     C     '>'           SCAN      PSrchStrng:I  C                        02
 
     C                   IF        *IN02 = *ON
     C                   EVAL      I = C + 1
     C                   ELSE
     C                   EVAL      WStrFnd = 'N'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      X = WSavStrtPos
     C                   EVAL      %SUBST(PSrchStrng:X) = '<' + %TRIM(PMTag) +
     C                               '>' + %TRIM(PValue) + '</' + %TRIM(PMTag)
     C                               + '>'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    POption
     C                   PARM                    PMTag
     C                   PARM                    PValue
     C                   PARM                    PSrchStrng
 
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2002
