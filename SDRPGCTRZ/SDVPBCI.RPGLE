     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Closed Indicator')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Private Bankings Validation   *
      *                                                               *
      *  SDVPBCI  - Validate Private Banking Closed Indicator         *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23513           Date 20Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 253211             Date 05Mar08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 ROLLPB             Date 23May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 181922             Date 25Jul00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23513 - Add missing parameter due to changes made to      *
      *             SD0010U. Apply GEMS fix 253823. Fix already       *
      *             covered by 253211                                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  253211 - Add parameter due to changes done to SD0010U.       *
      *           Apply fix 248959A.                                  *
      *  CER001 - LUX Upgrade to MidasPlus (recompile only)           *
      *  ROLLPB - Remove fix 181922 because of integration of         *
      *           "Customer Closing" feature within Core Midas:       *
      *            PB7201 -> CSD007                                   *
      *  181922 - Incorporation of Customer Closing within            *
      *           Meridian Solution                                   *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D @WCDS2          DS           200
     D   WDS2000               1    200
     D   WDS2001               1      1
     D   WDS2002               2      2
     D   WDS2003               3      3
     D   WDS2004               4      4
     D   WDS2005               5      5
     D   WDS2006               6      6
     D   WDS2007               7      7
     D   WDS2008               8      8
     D   WDS2009               9      9
     D   WDS2010              10     10
     D   WDS2011              11     11
     D   WDS2012              12     12
     D   WDS2013              13     13
     D   WDS2014              14     14
     D   WDS2015              15     15
     D   WDS2016              16     16
     D   WDS2017              17     17
     D   WDS2018              18     18
     D   WDS2019              19     19
     D   WDS2020              20     20
     D   WDS2021              21     21
     D   WDS2022              22     22
     D   WDS2023              23     23
     D   WDS2024              24     24
     D   WDS2025              25     25
     D   WDS2026              26     26
     D   WDS2027              27     27
     D   WDS2028              28     28
     D   WDS2029              29     29
     D   WDS2030              30     30
     D   WDS2031              31     31
     D   WDS2032              32     32
     D   WDS2033              33     33
     D   WDS2034              34     34
     D   WDS2035              35     35
     D   WDS2036              36     36
     D   WDS2037              37     37
     D   WDS2038              38     38
     D   WDS2039              39     39
     D   WDS2040              40     40
     D   WDS2041              41     41
     D   WDS2042              42     42
     D   WDS2043              43     43
     D   WDS2044              44     44
     D   WDS2045              45     45
     D   WDS2046              46     46
     D   WDS2047              47     47
     D   WDS2048              48     48
     D   WDS2049              49     49
     D   WDS2050              50     50
 
     D @WCDS4          DS           200
     D   WDS4000               1    200
     D   WDS4001               1      1
     D   WDS4002               2      2
     D   WDS4003               3      3
     D   WDS4004               4      4
     D   WDS4005               5      5
     D   WDS4006               6      6
     D   WDS4007               7      7
     D   WDS4008               8      8
     D   WDS4009               9      9
     D   WDS4010              10     10
     D   WDS4011              11     11
     D   WDS4012              12     12
     D   WDS4013              13     13
     D   WDS4014              14     14
     D   WDS4015              15     15
     D   WDS4016              16     16
     D   WDS4017              17     17
     D   WDS4018              18     18
     D   WDS4019              19     19
     D   WDS4020              20     20
     D   WDS4021              21     21
     D   WDS4022              22     22
     D   WDS4023              23     23
     D   WDS4024              24     24
     D   WDS4025              25     25
     D   WDS4026              26     26
     D   WDS4027              27     27
     D   WDS4028              28     28
     D   WDS4029              29     29
     D   WDS4030              30     30
     D   WDS4031              31     31
     D   WDS4032              32     32
     D   WDS4033              33     33
     D   WDS4034              34     34
     D   WDS4035              35     35
     D   WDS4036              36     36
     D   WDS4037              37     37
     D   WDS4038              38     38
     D   WDS4039              39     39
     D   WDS4040              40     40
     D   WDS4041              41     41
     D   WDS4042              42     42
     D   WDS4043              43     43
     D   WDS4044              44     44
     D   WDS4045              45     45
     D   WDS4046              46     46
     D   WDS4047              47     47
     D   WDS4048              48     48
     D   WDS4049              49     49
     D   WDS4050              50     50
 
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
 
      ** If the customer is already closed: no validation
 
     C     ClosePossible IFEQ      'C'
     C                   ELSE
      *
      ** VALIDATION
      *
     C                   EXSR      VCLST
 
     C                   ENDIF
      *
      *  *--------------------------------*
      *  * Validation for Close a customer
      *  *--------------------------------*
      *
      ** If there is a request to close the customer and if F10=Confirm
      *
     C     ClosePossible IFEQ      'Y'
     C     @INKJ         ANDEQ     '1'
      *
      ** Or if the request comes from 'Front Office'
      *
     C     ClosePossible OREQ      'A'
     C                   EXSR      VALAC
     C                   MOVE      'N'           ClosePossible
     C                   ENDIF
 
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCLSTOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     VCLST         BEGSR
 
      * Default Closure  Indicator is 'N'
     C     DDCLST        IFEQ      ' '
     C                   EVAL      DDCLST = 'N'
     C                   ENDIF
 
     C     DDPRBA        IFNE      'N'
      * Closure Indicator can only be 'Y' or 'N'
     C     DDCLST        IFNE      'Y'
     C     DDCLST        ANDNE     'N'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3928'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3928'     MsgIdXAr(Idx)                                CER001
     C                   ENDIF
     C                   ELSE
 
      * Status closure can be modify , only if it is a PB customer
     C     DDCLST        IFNE      ' '
     C     DDCLST        ANDNE     'N'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3929'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3929'     MsgIdXAr(Idx)                                CER001
     C                   ENDIF
     C                   ENDIF
 
     C     ENDVAL        ENDSR
      *****************************************************************
      *****************************************************************
      * VALC    - VALIDATION OF CLOSE REQUEST'
      *****************************************************************
     C     VALAC         BEGSR
      *
     C                   MOVEL     'N'           WUERCD            1
      *
      *  Customer Deletion Pre-checks - Client Details
      *
     C                   CALL      'SD0010U'                            90
     C                   PARM      DDCUSN        @CUST             6
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      *BLANK        @WCDS1          200                          253211
      * Customer Deln String 1
     C                   PARM      WDS2000       @WCDS2          200
      * Customer Deln String 2
     C                   PARM      WDS4000       @WCDS4          200
      * Quit program
     C                   PARM                    @WQUTP            1
     C                   PARM      'C'           PANCD             1
      *
      *  Call to program ended in error
      *
     C     *IN90         IFEQ      '1'
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C                   MOVEL     'Y2U0032'     MsgIdXAr(Idx)
     C                   MOVE      'N'           DDCLSTOK
     C                   GOTO      EVALAC
     C                   END
      *
      *  ERROR DETECTED ?
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     'REJECT'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3927'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3927'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * GENERAL LEDGER CHECKS:
      * Customer defined on ACCNT.
      * CASE: WRK.Customer Deln Flag 201 is Do not close
     C     WDS2001       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3930'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3930'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * CUSTOMER LENDING CHECKS:
      * Customer defined on FACIL.
      * CASE: WRK.Customer Deln Flag 203 is Do not close
     C     WDS2003       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3931'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3931'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer has a live facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 204 is Do not Close
      * Customer has a reversed facility defined on FCLTY.
     C     WDS2004       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3932'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3932'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer has a reversed facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 207 is Do not close
     C     WDS2007       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3933'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3933'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer has a closed facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 208 is Do not Close
     C     WDS2008       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3934'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3934'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer has an expired facility defined on FCLTY.
      * CASE: WRK.Customer Deln Flag 209 is Do not delete
     C     WDS2009       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3935'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3935'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer defined on LEREF.
      * CASE: WRK.Customer Deln Flag 206 is Do not Close
     C     WDS2006       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3936'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3936'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer defined on CLOANCL.
      * CASE: WRK.Customer Deln Flag 230 is Do not delete
     C     WDS2030       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3937'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3937'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * Customer defined on GTEES.
      * CASE: WRK.Customer Deln Flag 205 is Do not Close
      * Customer defined on LEREF.
     C     WDS2005       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3938'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3938'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * DEALING CHECKS:
      * Customer defined on CUSDL.
      * CASE: WRK.Customer Deln Flag 202 is Do not delete
     C     WDS2002       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3939'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3939'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * EXPOSURE MANAGEMENT CHECKS:
      * Customer defined on EMLIML2.
      * CASE: WRK.Customer Deln Flag 212 is Do not Close
     C     WDS2012       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3940'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3940'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * User Defined Correspondence
      * CASE: WRK.Customer Deln Flag 218 is Do not close
     C     WDS2018       IFEQ      'F'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR3926'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX3926'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'Y'           WUERCD
     C                   GOTO      EVALAC
     C                   END
      * End of change S01424 - Customer Close
      * Check to see if all the checks have been successfully completed.
      * CASE: WRK.Err Code is Error Found
     C     WUERCD        IFEQ      'Y'
     C                   MOVE      'N'           DDCLSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCLST'      FldNamXAr(Idx)
     C**********         MOVEL     'USR0152'     MsgIdXAr(Idx)                                CER001
     C                   MOVEL     'LUX0152'     MsgIdXAr(Idx)                                CER001
     C                   GOTO      EVALAC
     C                   END
     C*
     C*
     C     EVALAC        ENDSR
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
      ** Other parms
      *
      ** Closed Indicator
     C                   PARM                    DDCLST            1
      *
      ** Private Banking Customer
     C                   PARM                    DDPRBA            1
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Valid Closed Indicator - OK
     C                   PARM                    DDCLSTOK          1
      *
      ** F=10 Confirm Closed Indicator
     C                   PARM                    @INKJ             1
      *
      * Close request
     C                   PARM                    ClosePossible     1
      * Customer Number
     C                   PARM                    DDCUSN            6
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
(c) Finastra International Limited 2005
