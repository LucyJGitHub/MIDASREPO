     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Fees/Buy-Outs Amend checking')                *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSFBOAMD - Fees/Buy-Outs Amend Checking                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 245691             Date 11Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP041  *CREATE    Date 07Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  245691 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,IRSFBOV001
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
     D                                     PREFIX(A)
      *
      ** Transaction Details retrieved from file - in screen
      ** format
     D CrFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D/COPY QWINDSRC,IRSIRSGDTA
      *
      ** Index for arrays of of error message ids etc
     D IDx             S              3P 0
      *
      ** Parameters for ZALIGN
     D PZField         S             16A
     D PZADec          S              1P 0
     D PZADig          S              2P 0
     D PZalignOk       S              1A
      *
      ** Work parameters
     D PAmendOk        S              1A
     D PResetFld       S              1A
     D CIR007          S              1A
 
     D WBUYA           S             13P 0
     D AWBUYA          S             13P 0
     D WUFEE           S             13P 0
     D AWUFEE          S             13P 0
     D PWUCDP          S              1P 0
     D PWTCDP          S              1P 0
     D BJRDNB          S              5P 0
 
      ** Decimal separator                                                                    245691
     D BNDCSP          S              1A                                                      245691
                                                                                              245691
      ** Parameter list for ZA0840                                                            245691
      ** =========================                                                            245691
      ** Return code for numeric validation module call                                       245691
     D @Rtcde          S             10A                                                      245691
      ** Alpha field for numeric validation                                                   245691
     D @@ALPH          S             16A                                                      245691
      ** Number of decimal places field for numeric validation                                245691
     D @@IDP           S              2  0                                                    245691
      ** Number of integers field for numeric validation                                      245691
     D @@IINT          S              2  0                                                    245691
      ** Millions/Thousands id (Y=function on)                                                245691
     D @@MTID          S              1A                                                      245691
      ** Amount calculation field                                                             245691
     D @@AMT           S             15  0                                                    245691
      ** Error return code for ZA0840 module                                                  245691
     D @@ERCD          S              1  0                                                    245691
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,IRSFBOV002
 
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
      ** Check if non-amendable fields were amended.
      *
     C                   EXSR      SRCompare
      *
      ** If any errors were found, set Amendments OK Indicator to 'N'.
      *
     C     IDx           IFGT      0
     C                   EVAL      PAmendOK = 'N'
     C                   ELSE
     C                   EVAL      PAmendOK = 'Y'
     C                   ENDIF
      *
      ** If any errors were found and Reset of Fields in Error
      ** required, do this:
      *
     C     IDx           IFGT      0
     C     PResetFld     ANDEQ     'Y'
     C                   EXSR      SRResetFlds
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCompare - Routine to compare fields from file and the      *
      *              amended screen fields                            *
      *                                                               *
      *****************************************************************
      *
     C     SRCompare     BEGSR
      *
      ** Up-front fee details is not amendable if original entry date
      ** is not equal to rundate.
      *
     C     #1ACTN        IFEQ      'A'
     C     BJRDNB        ANDGT     #1UPVD
     C     #1UPVD        ANDNE     *ZERO
      *
      ** Up-Front Fee Value date
      *
     C     SUFVD         IFNE      ASUFVD
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SUFVD'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00022'
     C                   EVAL      OKUFVD          = 'N'
     C                   ENDIF
      *
      ** Up-Front Fee Amount
      *
     C                   Z-ADD     *ZERO         WUFEE
     C**********         MOVE      *BLANKS       PZField                                      245691
     C**********         MOVE      SUFEE         PZField                                      245691
     C                   MOVE      *BLANKS       @@ALPH                                       245691
     C                   MOVE      SUFEE         @@ALPH                                       245691
 
     C                   IF        SUFPR = 'P'
     C                   Z-ADD     PWUCDP        PZADec
     C                   Z-ADD     PWUCDP        @@IDP                                        245691
     C                   ELSE
     C                   Z-ADD     PWTCDP        PZADec
     C                   Z-ADD     PWTCDP        @@IDP                                        245691
     C                   ENDIF
     C     13            SUB       PZADec        PZADig
     C     13            SUB       PZADec        @@IINT                                       245691
     C                   MOVE      'N'           @@MTID                                       245691
 
     C**********         CALLB     'ZALIGN'                                                   245691
     C**********         PARM      *BLANK        PZALIGNok                                    245691
     C**********         PARM                    PZField                                      245691
     C**********         PARM                    PZADec                                       245691
     C**********         PARM                    PZADig                                       245691
     C                   CALLB     'ZA0840'                                                   245691
     C                   PARM                    @Rtcde                                       245691
     C                   PARM                    @@ALPH                                       245691
     C                   PARM                    @@IDP                                        245691
     C                   PARM                    @@IINT                                       245691
     C                   PARM                    @@MTID                                       245691
     C                   PARM                    @@ERCD                                       245691
     C                   PARM                    @@AMT                                        245691
     C                   PARM                    BNDCSP                                       245691
 
     C**********         MOVE      PZField       WUFEE                                        245691
     C                   MOVE      @@AMT         WUFEE                                        245691
 
     C                   Z-ADD     *ZERO         AWUFEE
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      ASUFEE        PZField
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZALIGNok
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   PARM                    PZADig
 
     C                   MOVE      PZField       AWUFEE
 
     C     WUFEE         IFNE      AWUFEE
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SUFEE'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00023'
     C                   EVAL      OKUFEE          = 'N'
     C                   ENDIF
      *
      ** Up-Front Fee Pay/Receive indicator
      *
     C     SUFPR         IFNE      ASUFPR
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SUFPR'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00024'
     C                   EVAL      OKUFPR          = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Buy-out details is not amendable if rundate is greater
      ** than buy-out deal date and deal date is not zero.
      *
     C                   EVAL      *IN01 = *OFF
 
     C     #1ACTN        IFEQ      'A'
     C     BJRDNB        ANDGT     #1BODD
     C     #1BODD        ANDNE     *ZERO
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
      *
      ** Buy-out details can only be entered if value
      ** date of the deal has passed
      ** Buy-outs will not be available for OIS Deals.
      *
     C     #1ACTN        IFEQ      'I'
     C     #1ACTN        OREQ      'A'
     C     #1VDAT        IFGT      BJRDNB
     C     #1UICF        OREQ      'O'
     C     CIR007        ANDEQ     'Y'
     C     #1TICF        OREQ      'O'
     C     CIR007        ANDEQ     'Y'
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN01
      *
      ** Buy-Out Value date
      *
     C     SBOVD         IFNE      ASBOVD
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SBOVD'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00025'
     C                   EVAL      OKBOVD          = 'N'
     C                   ENDIF
      *
      ** Buy-Out Amount
      *
     C                   Z-ADD     *ZERO         WBUYA
     C**********         MOVE      *BLANKS       PZField                                      245691
     C**********         MOVE      SBUYA         PZField                                      245691
     C                   MOVE      *BLANKS       @@ALPH                                       245691
     C                   MOVE      SBUYA         @@ALPH                                       245691
 
     C                   IF        SBOPR = 'P'
     C                   Z-ADD     PWUCDP        PZADec
     C                   Z-ADD     PWUCDP        @@IDP                                        245691
     C                   ELSE
     C                   Z-ADD     PWTCDP        PZADec
     C                   Z-ADD     PWTCDP        @@IDP                                        245691
     C                   ENDIF
     C     13            SUB       PZADec        PZADig
     C     13            SUB       PZADec        @@IINT                                       245691
     C                   MOVE      'N'           @@MTID                                       245691
 
     C**********         CALLB     'ZALIGN'                                                   245691
     C**********         PARM      *BLANK        PZALIGNok                                    245691
     C**********         PARM                    PZField                                      245691
     C**********         PARM                    PZADec                                       245691
     C**********         PARM                    PZADig                                       245691
     C                   CALLB     'ZA0840'                                                   245691
     C                   PARM                    @Rtcde                                       245691
     C                   PARM                    @@ALPH                                       245691
     C                   PARM                    @@IDP                                        245691
     C                   PARM                    @@IINT                                       245691
     C                   PARM                    @@MTID                                       245691
     C                   PARM                    @@ERCD                                       245691
     C                   PARM                    @@AMT                                        245691
     C                   PARM                    BNDCSP                                       245691
 
     C**********         MOVE      PZField       WBUYA                                        245691
     C                   MOVE      @@AMT         WBUYA                                        245691
 
     C                   Z-ADD     *ZERO         AWBUYA
     C                   MOVE      *BLANKS       PZField
     C                   MOVE      ASBUYA        PZField
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    PZALIGNok
     C                   PARM                    PZField
     C                   PARM                    PZADec
     C                   PARM                    PZADig
 
     C                   MOVE      PZField       AWBUYA
 
     C     WBUYA         IFNE      AWBUYA
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SBUYA'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00026'
     C                   EVAL      OKBUYA          = 'N'
     C                   ENDIF
      *
      ** Up-Front Fee Pay/Receive indicator
      *
     C     SBOPR         IFNE      ASBOPR
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SBOPR'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00027'
     C                   EVAL      OKBOPR          = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Interest processing method is not amendable.
      *
     C     #1ACTN        IFNE      'I'
      *
      ** Our Interest Processing Method
      *
     C     SOIPM         IFNE      ASOIPM
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'SOIPM'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00028'
     C                   EVAL      OKOIPM          = 'N'
     C                   ENDIF
      *
      ** Their Interest Processing Method
      *
     C     STIPM         IFNE      ASTIPM
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'STIPM'
     C                   EVAL      MsgIdArr(IDx)  = 'RS00028'
     C                   EVAL      OKTIPM          = 'N'
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFlds - Reset Fields in Error with their values on     *
      *                file                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFlds   BEGSR
      *
      ** Up-Front Fee Value date
      *
     C     OKUFVD        IFEQ      'N'
     C                   EVAL      ASUFVD = SUFVD
     C                   ENDIF
      *
      ** Up-Front Fee Amount
      *
     C     OKUFEE        IFEQ      'N'
     C                   EVAL      ASUFEE = SUFEE
     C                   ENDIF
      *
      ** Up-Front Fee Pay/Receive indicator
      *
     C     OKUFPR        IFEQ      'N'
     C                   EVAL      ASUFPR = SUFPR
     C                   ENDIF
      *
      ** Buy-Out Value date
      *
     C     OKBOVD        IFEQ      'N'
     C                   EVAL      ASBOVD = SBOVD
     C                   ENDIF
      *
      ** Buy-Out Amount
      *
     C     OKBUYA        IFEQ      'N'
     C                   EVAL      ASBUYA = SBUYA
     C                   ENDIF
      *
      ** Buy-Out Pay/Receive Indicator
      *
     C     OKBOPR        IFEQ      'N'
     C                   EVAL      ASBOPR = SBOPR
     C                   ENDIF
      *
      ** Interest Processing Method
      *
     C     OKOIPM        IFEQ      'N'
     C                   EVAL      ASOIPM = SOIPM
     C                   ENDIF
 
     C     OKTIPM        IFEQ      'N'
     C                   EVAL      ASTIPM = STIPM
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** Transaction Details retrieved from file - in screen
     C                   PARM                    CrFBScnFmt
      *
      ** Deal information details
     C                   PARM                    Data
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM                    PResetFld
      *
      ** Decimal Places based on Up-Front Pay/Receive (Our)
     C                   PARM                    PWUCDP
      *
      ** Decimal Places based on Up-Front Pay/Receive (Their)
     C                   PARM                    PWTCDP
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Rundate
     C                   PARM                    BJRDNB
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Overnight index swaps
     C                   PARM                    CIR007
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
     C                   PARM                    BNDCSP                                       245691
 
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
(c) Finastra International Limited 2002
